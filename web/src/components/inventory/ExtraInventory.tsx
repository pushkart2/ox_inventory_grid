import React, { useCallback, useState } from 'react';
import { Inventory } from '../../typings';
import { usePanelDrag } from '../../hooks/usePanelDrag';
import { isGridInventory } from '../../helpers/gridUtils';
import GridInventory from './GridInventory';
import InventoryGrid from './InventoryGrid';

interface Props {
  inventory: Inventory;
  index: number;
}

const PANEL_WIDTH = 370;
const PANEL_GAP = 8;

const ExtraInventory: React.FC<Props> = ({ inventory, index }) => {
  const storageKey = `ox_inv_panel_extra_${inventory.id}`;
  const drag = usePanelDrag(storageKey);
  const [focusedLocal, setFocusedLocal] = useState(false);

  const handleHeaderDown = useCallback(
    (e: React.MouseEvent) => {
      setFocusedLocal(true);
      if (drag.isLocked) return;
      drag.onMouseDown(e);
    },
    [drag.onMouseDown, drag.isLocked]
  );

  const positioned = drag.position !== null;

  const defaultStyle: React.CSSProperties = positioned
    ? {
        left: drag.position!.x,
        top: drag.position!.y,
        zIndex: focusedLocal ? 150 : 120,
      }
    : {
        right: `calc(var(--right-panel-right, 0px) + ${index * (PANEL_WIDTH + PANEL_GAP)}px)`,
        zIndex: focusedLocal ? 150 : 120,
      };

  const canSort = inventory.type !== 'player';

  return (
    <div
      ref={drag.panelRef}
      className={`inventory-panel inventory-panel--extra inventory-panel--active${positioned ? ' inventory-panel--positioned' : ''}${drag.isDragging ? ' inventory-panel--dragging' : ''}`}
      style={defaultStyle}
      onMouseDown={() => setFocusedLocal(true)}
    >
      {isGridInventory(inventory.type) ? (
        <GridInventory
          inventory={inventory}
          onHeaderMouseDown={handleHeaderDown}
          isLocked={drag.isLocked}
          onToggleLock={drag.toggleLock}
          canSort={canSort}
        />
      ) : (
        <InventoryGrid
          inventory={inventory}
          onHeaderMouseDown={handleHeaderDown}
          isLocked={drag.isLocked}
          onToggleLock={drag.toggleLock}
        />
      )}
    </div>
  );
};

export default ExtraInventory;
