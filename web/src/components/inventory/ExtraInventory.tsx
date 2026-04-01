import React, { useCallback, useLayoutEffect, useState } from 'react';
import { Inventory } from '../../typings';
import { usePanelDrag } from '../../hooks/usePanelDrag';
import { isGridInventory } from '../../helpers/gridUtils';
import GridInventory from './GridInventory';
import InventoryGrid from './InventoryGrid';

interface Props {
  inventory: Inventory;
  index: number;
}

const PANEL_GAP = 16;

const ExtraInventory: React.FC<Props> = ({ inventory, index }) => {
  // Use stable key for drop panels so position persists when newdrop → real drop
  const storageKey = (inventory.type === 'drop' || inventory.type === 'newdrop')
    ? 'ox_inv_panel_extra_drop'
    : `ox_inv_panel_extra_${inventory.id}`;
  const drag = usePanelDrag(storageKey);
  const [focusedLocal, setFocusedLocal] = useState(false);
  const [autoPositioned, setAutoPositioned] = useState(false);

  // Auto-position on mount: find all existing panels and place to the right of them
  useLayoutEffect(() => {
    if (drag.position !== null) return; // already has a saved/set position
    if (autoPositioned) return;

    const el = drag.panelRef.current;
    if (!el) return;

    // Collect bounding rects of all visible panels except this one
    const allPanels = document.querySelectorAll(
      '.inventory-panel--positioned, .inventory-panel:not(.inventory-panel--extra):not([style*="opacity: 0"])'
    );
    const rects: DOMRect[] = [];
    allPanels.forEach((panel) => {
      if (panel === el) return;
      // Skip invisible panels
      const style = getComputedStyle(panel);
      if (style.opacity === '0' || style.display === 'none') return;
      rects.push(panel.getBoundingClientRect());
    });

    // Also collect other positioned extra panels
    const extraPanels = document.querySelectorAll('.inventory-panel--extra.inventory-panel--positioned');
    extraPanels.forEach((panel) => {
      if (panel === el) return;
      rects.push(panel.getBoundingClientRect());
    });

    if (rects.length === 0) {
      // No other panels — center on screen
      const panelWidth = el.offsetWidth || 400;
      drag.setPosition({
        x: (window.innerWidth - panelWidth) / 2,
        y: window.innerHeight * 0.1,
      });
      setAutoPositioned(true);
      return;
    }

    const panelWidth = el.offsetWidth || 400;
    const panelHeight = el.offsetHeight || 300;

    // Find the rightmost edge of all existing panels
    const rightEdge = Math.max(...rects.map((r) => r.right));
    const topEdge = Math.min(...rects.map((r) => r.top));

    let x = rightEdge + PANEL_GAP;
    let y = topEdge;

    // If it would go off the right edge of the screen, try placing below
    if (x + panelWidth > window.innerWidth - 16) {
      // Find space below existing panels
      const bottomEdge = Math.max(...rects.map((r) => r.bottom));
      const leftEdge = Math.min(...rects.map((r) => r.left));

      x = leftEdge;
      y = bottomEdge + PANEL_GAP;

      // If that's also off-screen, just clamp
      if (y + panelHeight > window.innerHeight - 16) {
        x = Math.max(16, window.innerWidth - panelWidth - 16);
        y = Math.max(16, window.innerHeight - panelHeight - 16);
      }
    }

    // Clamp to viewport
    x = Math.max(0, Math.min(x, window.innerWidth - panelWidth));
    y = Math.max(0, Math.min(y, window.innerHeight - panelHeight));

    drag.setPosition({ x, y });
    setAutoPositioned(true);
  }, [drag.position, autoPositioned]);

  const handleHeaderDown = useCallback(
    (e: React.MouseEvent) => {
      setFocusedLocal(true);
      if (drag.isLocked) return;
      drag.onMouseDown(e);
    },
    [drag.onMouseDown, drag.isLocked]
  );

  const positioned = drag.position !== null;

  const style: React.CSSProperties = positioned
    ? {
        left: drag.position!.x,
        top: drag.position!.y,
        zIndex: focusedLocal ? 150 : 120,
      }
    : {
        // Hidden until auto-positioned to prevent flash at wrong location
        visibility: 'hidden' as const,
        position: 'fixed' as const,
        zIndex: focusedLocal ? 150 : 120,
      };

  const canSort = inventory.type !== 'player';

  return (
    <div
      ref={drag.panelRef}
      className={`inventory-panel inventory-panel--extra inventory-panel--active${positioned ? ' inventory-panel--positioned' : ''}${drag.isDragging ? ' inventory-panel--dragging' : ''}`}
      style={style}
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
