import { describe, it, expect, vi } from 'vitest';

vi.mock('../../../web/src/reducers/setupInventory', () => ({
  setupGridInventory: (inv: any) => inv,
  setupSlotInventory: (inv: any) => inv,
  setupInventoryReducer: (state: any) => state,
}));
vi.mock('../../../web/src/helpers', async () => {
  const actual = await vi.importActual('../../../web/src/helpers') as any;
  return { ...actual, itemDurability: () => 100 };
});

import { inventorySlice } from '../../../web/src/store/inventory';
import { makeItem, makeInventory, makeState } from '../testUtils';

const reducer = inventorySlice.reducer;
const { gridSwapSlots } = inventorySlice.actions;

describe('gridSwapSlotsReducer', () => {
  it('should swap items across different inventories', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 3, weight: 300, gridX: 0, gridY: 0, metadata: {} });
    const toItem = makeItem({ slot: 5, name: 'bread', count: 1, weight: 200, gridX: 2, gridY: 2, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [toItem] }),
    });

    const result = reducer(state, gridSwapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
    }));

    // Source inventory should now have the target item (bread) with fromSlot's slot number
    const sourceItem = result.leftInventory.items.find((i: any) => i.name === 'bread');
    expect(sourceItem).toBeDefined();
    expect(sourceItem!.slot).toBe(1);
    expect(sourceItem!.gridX).toBe(0);
    expect(sourceItem!.gridY).toBe(0);

    // Target inventory should now have the source item (water) with toSlot's slot number
    const targetItem = result.rightInventory.items.find((i: any) => i.name === 'water');
    expect(targetItem).toBeDefined();
    expect(targetItem!.slot).toBe(5);
    expect(targetItem!.gridX).toBe(2);
    expect(targetItem!.gridY).toBe(2);
  });

  it('should swap items within the same inventory', () => {
    const itemA = makeItem({ slot: 1, name: 'water', count: 2, weight: 200, gridX: 0, gridY: 0, metadata: {} });
    const itemB = makeItem({ slot: 2, name: 'bread', count: 1, weight: 150, gridX: 3, gridY: 3, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [itemA, itemB] }),
    });

    const result = reducer(state, gridSwapSlots({
      fromSlot: itemA,
      fromType: 'player',
      toSlot: itemB,
      toType: 'player',
    }));

    // Same inventory swap: positions should be exchanged but slots stay the same
    const swappedA = result.leftInventory.items.find((i: any) => i.slot === 1);
    const swappedB = result.leftInventory.items.find((i: any) => i.slot === 2);

    expect(swappedA).toBeDefined();
    expect(swappedA!.gridX).toBe(3); // took B's position
    expect(swappedA!.gridY).toBe(3);

    expect(swappedB).toBeDefined();
    expect(swappedB!.gridX).toBe(0); // took A's position
    expect(swappedB!.gridY).toBe(0);
  });

  it('should handle dragRotated for the source item', () => {
    const fromItem = makeItem({ slot: 1, name: 'rifle', count: 1, weight: 3000, gridX: 0, gridY: 0, rotated: false, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'pistol', count: 1, weight: 1000, gridX: 4, gridY: 1, rotated: false, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem, toItem] }),
    });

    const result = reducer(state, gridSwapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
      dragRotated: true,
    }));

    const swappedSource = result.leftInventory.items.find((i: any) => i.slot === 1);
    expect(swappedSource!.rotated).toBe(true); // dragRotated applied
  });

  it('should handle rotateTarget to flip target item rotation', () => {
    const fromItem = makeItem({ slot: 1, name: 'rifle', count: 1, weight: 3000, gridX: 0, gridY: 0, rotated: false, metadata: {} });
    const toItem = makeItem({ slot: 5, name: 'pistol', count: 1, weight: 1000, gridX: 3, gridY: 2, rotated: false, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [toItem] }),
    });

    const result = reducer(state, gridSwapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
      rotateTarget: true,
    }));

    // Target item (pistol) should have its rotation toggled (was false -> now true)
    const movedTarget = result.leftInventory.items.find((i: any) => i.name === 'pistol');
    expect(movedTarget).toBeDefined();
    expect(movedTarget!.rotated).toBe(true);
  });

  it('should set durability to 100 on swapped items', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 1, weight: 100, gridX: 0, gridY: 0, durability: 50, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'bread', count: 1, weight: 100, gridX: 2, gridY: 2, durability: 30, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem, toItem] }),
    });

    const result = reducer(state, gridSwapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
    }));

    // Both items should have durability set by the mocked itemDurability (100)
    expect(result.leftInventory.items[0].durability).toBe(100);
    expect(result.leftInventory.items[1].durability).toBe(100);
  });
});
