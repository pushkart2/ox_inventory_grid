import React, { useState, useMemo, useCallback, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { batch } from 'react-redux';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryHotbar from './InventoryHotbar';
import { useAppDispatch, useAppSelector } from '../../store';
import { refreshSlots, setAdditionalMetadata, setupInventory, restoreHotbar, selectRightInventory, selectBackpackInventory, selectClothingInventory, setupBackpack, closeBackpack, setupClothing, closeClothing, clearCraftQueue, addExtraInventory, removeExtraInventory, clearExtraInventories } from '../../store/inventory';
import ExtraInventory from './ExtraInventory';
import { reconcileHotbar } from '../../helpers/hotbarPersistence';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';
import { DragSource } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';
import BackpackInventory from './BackpackInventory';
import ClothingInventory from './ClothingInventory';
import Tooltip from '../utils/Tooltip';
import { closeTooltip } from '../../store/tooltip';
import InventoryContext from './InventoryContext';
import { closeContextMenu } from '../../store/contextMenu';
import Fade from '../utils/transitions/Fade';
import UsefulControls from './UsefulControls';
import { usePanelDrag } from '../../hooks/usePanelDrag';

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = useState(false);
  const [infoVisible, setInfoVisible] = useState(false);
  const [focusedPanel, setFocusedPanel] = useState<'left' | 'right'>('left');
  const dispatch = useAppDispatch();
  const rightInventory = useAppSelector(selectRightInventory);
  const hasRightInventory = useMemo(() => {
    if (rightInventory.type === '' || rightInventory.id === '') return false;
    return true;
  }, [rightInventory.type, rightInventory.id]);

  const backpackInventory = useAppSelector(selectBackpackInventory);
  const hasBackpack = useMemo(() =>
    backpackInventory.type === 'backpack' && backpackInventory.id !== '',
    [backpackInventory.type, backpackInventory.id]
  );
  const clothingInventory = useAppSelector(selectClothingInventory);
  const hasClothing = useMemo(() =>
    clothingInventory.type === 'clothing' && clothingInventory.id !== '',
    [clothingInventory.type, clothingInventory.id]
  );
  const extraInventories = useAppSelector((state) => state.inventory.extraInventories);

  const leftDrag = usePanelDrag('ox_inv_panel_left');
  const rightDrag = usePanelDrag('ox_inv_panel_right');
  const backpackDrag = usePanelDrag('ox_inv_panel_backpack');
  // clothingDrag removed — clothing panel is fixed position

  useEffect(() => {
    if (hasRightInventory && !rightDrag.position) {
      const leftEl = leftDrag.panelRef.current;
      if (leftEl) {
        const leftRect = leftEl.getBoundingClientRect();
        const leftPos = leftDrag.position ?? { x: leftRect.left, y: leftRect.top };
        rightDrag.setPosition({
          x: leftPos.x + leftEl.offsetWidth + 16,
          y: leftPos.y,
        });
      }
    }
  }, [hasRightInventory]);

  const handleLeftHeaderDown = useCallback((e: React.MouseEvent) => {
    setFocusedPanel('left');
    if (leftDrag.isLocked) return;
    if (!leftDrag.position && rightDrag.panelRef.current && !rightDrag.position) {
      rightDrag.capturePosition();
    }
    leftDrag.onMouseDown(e);
  }, [leftDrag.onMouseDown, leftDrag.position, leftDrag.isLocked, rightDrag.position, rightDrag.capturePosition]);

  const handleRightHeaderDown = useCallback((e: React.MouseEvent) => {
    setFocusedPanel('right');
    if (rightDrag.isLocked) return;
    if (!rightDrag.position && leftDrag.panelRef.current && !leftDrag.position) {
      leftDrag.capturePosition();
    }
    rightDrag.onMouseDown(e);
  }, [rightDrag.onMouseDown, rightDrag.position, rightDrag.isLocked, leftDrag.position, leftDrag.capturePosition]);

  const handleBackpackHeaderDown = useCallback((e: React.MouseEvent) => {
    setFocusedPanel('left');
    if (backpackDrag.isLocked) return;
    backpackDrag.onMouseDown(e);
  }, [backpackDrag.onMouseDown, backpackDrag.isLocked]);

  // clothing panel is fixed — no drag handler needed

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    batch(() => {
      setInventoryVisible(false);
      setInfoVisible(false);
      dispatch(closeContextMenu());
      dispatch(closeTooltip());
      dispatch(clearCraftQueue());
      dispatch(closeClothing());
      dispatch(clearExtraInventories());
    });
  });
  useExitListener(setInventoryVisible);

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    if (data.leftInventory) {
      dispatch(restoreHotbar(reconcileHotbar(data.leftInventory.items)));
    }
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent<{ backpackInventory: InventoryProps }>('setupBackpack', (data) => {
    dispatch(setupBackpack(data.backpackInventory));
  });
  useNuiEvent('closeBackpack', () => dispatch(closeBackpack()));

  useNuiEvent<{ clothingInventory: InventoryProps }>('setupClothing', (data) => {
    dispatch(setupClothing(data.clothingInventory));
  });
  useNuiEvent('closeClothing', () => dispatch(closeClothing()));

  useNuiEvent('displayMetadata', (data: Array<{ metadata: string; value: string }>) => {
    dispatch(setAdditionalMetadata(data));
  });

  useNuiEvent('addSecondaryInventory', (data: InventoryProps) => {
    dispatch(addExtraInventory(data));
  });
  useNuiEvent('removeSecondaryInventory', (id: string) => dispatch(removeExtraInventory(id)));

  // Catch items dropped outside any panel - just cancel the drag (do nothing)
  const [, groundDrop] = useDrop<DragSource, void, {}>(() => ({
    accept: ['GRID_ITEM', 'SLOT'],
    drop: () => {},
  }), []);

  const leftPositioned = leftDrag.position !== null;
  const rightPositioned = rightDrag.position !== null;
  const backpackPositioned = backpackDrag.position !== null;

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <Fade in={inventoryVisible}>
        <div ref={groundDrop} className="inventory-wrapper">
          <div
            className={`inventory-panel inventory-panel--clothing inventory-panel--positioned${hasClothing ? ' inventory-panel--active' : ''}`}
            style={{ left: 16, top: '50%', transform: 'translateY(-50%)' }}
          >
            {hasClothing && (
              <ClothingInventory />
            )}
          </div>
          <div
            ref={leftDrag.panelRef}
            className={`inventory-panel inventory-panel--left${leftPositioned ? ' inventory-panel--positioned' : ''}${leftDrag.isDragging ? ' inventory-panel--dragging' : ''}`}
            style={leftPositioned ? {
              left: leftDrag.position!.x,
              top: leftDrag.position!.y,
              zIndex: focusedPanel === 'left' ? 100 : 50,
            } : {
              zIndex: focusedPanel === 'left' ? 100 : 50,
            }}
            onMouseDown={() => setFocusedPanel('left')}
          >
            <LeftInventory
              onHeaderMouseDown={handleLeftHeaderDown}
              isLocked={leftDrag.isLocked}
              onToggleLock={leftDrag.toggleLock}
            />
          </div>
          <div
            ref={backpackDrag.panelRef}
            className={`inventory-panel inventory-panel--backpack${hasBackpack ? ' inventory-panel--active' : ''}${backpackPositioned ? ' inventory-panel--positioned' : ''}${backpackDrag.isDragging ? ' inventory-panel--dragging' : ''}`}
            style={backpackPositioned ? {
              left: backpackDrag.position!.x,
              top: backpackDrag.position!.y,
            } : {}}
          >
            {hasBackpack && (
              <BackpackInventory
                onHeaderMouseDown={handleBackpackHeaderDown}
                isLocked={backpackDrag.isLocked}
                onToggleLock={backpackDrag.toggleLock}
              />
            )}
          </div>
          <div
            ref={rightDrag.panelRef}
            className={`inventory-panel inventory-panel--right${hasRightInventory ? ' inventory-panel--active' : ''}${rightPositioned ? ' inventory-panel--positioned' : ''}${rightDrag.isDragging ? ' inventory-panel--dragging' : ''}`}
            style={rightPositioned ? {
              left: rightDrag.position!.x,
              top: rightDrag.position!.y,
              zIndex: focusedPanel === 'right' ? 100 : 50,
            } : {
              zIndex: focusedPanel === 'right' ? 100 : 50,
            }}
            onMouseDown={() => setFocusedPanel('right')}
          >
            {hasRightInventory && (
              <RightInventory
                onHeaderMouseDown={handleRightHeaderDown}
                isLocked={rightDrag.isLocked}
                onToggleLock={rightDrag.toggleLock}
              />
            )}
          </div>
          {extraInventories.map((inv, i) => (
            <ExtraInventory key={(inv.type === 'drop' || inv.type === 'newdrop') ? 'drop-panel' : inv.id} inventory={inv} index={i} />
          ))}
          <Tooltip />
          <InventoryContext />
          <button className="useful-controls-button" onClick={() => setInfoVisible(true)}>
            <svg xmlns="http://www.w3.org/2000/svg" height="2em" viewBox="0 0 524 524">
              <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" />
            </svg>
          </button>
        </div>
      </Fade>
      <InventoryHotbar />
    </>
  );
};

export default Inventory;
