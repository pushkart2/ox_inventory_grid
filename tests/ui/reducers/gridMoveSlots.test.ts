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
const { gridMoveSlots } = inventorySlice.actions;

describe('gridMoveSlotsReducer', () => {
  it('should fully move an item from left to right inventory', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 5, weight: 500, gridX: 0, gridY: 0 });
    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [] }),
    });

    const result = reducer(state, gridMoveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toType: 'stash',
      toSlotId: 10,
      count: 5,
      toGridX: 2,
      toGridY: 3,
      rotated: false,
    }));

    // Item should be removed from source
    expect(result.leftInventory.items).toHaveLength(0);
    // Item should appear in target
    expect(result.rightInventory.items).toHaveLength(1);
    expect(result.rightInventory.items[0].slot).toBe(10);
    expect(result.rightInventory.items[0].gridX).toBe(2);
    expect(result.rightInventory.items[0].gridY).toBe(3);
    expect(result.rightInventory.items[0].count).toBe(5);
    expect(result.rightInventory.items[0].weight).toBe(500);
  });

  it('should partially move an item, leaving remainder in source', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, gridX: 0, gridY: 0 });
    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [] }),
    });

    const result = reducer(state, gridMoveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toType: 'stash',
      toSlotId: 5,
      count: 3,
      toGridX: 1,
      toGridY: 1,
      rotated: true,
    }));

    // Source should have remaining items
    expect(result.leftInventory.items).toHaveLength(1);
    expect(result.leftInventory.items[0].count).toBe(7);
    expect(result.leftInventory.items[0].weight).toBe(700);
    // Target should have moved items
    expect(result.rightInventory.items).toHaveLength(1);
    expect(result.rightInventory.items[0].count).toBe(3);
    expect(result.rightInventory.items[0].weight).toBe(300);
    expect(result.rightInventory.items[0].rotated).toBe(true);
  });

  it('should move within the same inventory by updating grid position', () => {
    const fromItem = makeItem({ slot: 1, name: 'bread', count: 2, weight: 200, gridX: 0, gridY: 0 });
    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
    });

    const result = reducer(state, gridMoveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toType: 'player',
      toSlotId: 1,
      count: 2,
      toGridX: 5,
      toGridY: 2,
      rotated: true,
    }));

    // Same inventory: item count stays the same, position updated
    expect(result.leftInventory.items).toHaveLength(1);
    expect(result.leftInventory.items[0].gridX).toBe(5);
    expect(result.leftInventory.items[0].gridY).toBe(2);
    expect(result.leftInventory.items[0].rotated).toBe(true);
  });

  it('should correctly calculate weight based on per-piece weight', () => {
    const fromItem = makeItem({ slot: 1, name: 'ammo', count: 20, weight: 400, gridX: 0, gridY: 0 });
    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [] }),
    });

    const result = reducer(state, gridMoveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toType: 'stash',
      toSlotId: 2,
      count: 5,
      toGridX: 0,
      toGridY: 0,
      rotated: false,
    }));

    // pieceWeight = 400/20 = 20 per item
    expect(result.rightInventory.items[0].weight).toBe(100); // 5 * 20
    expect(result.leftInventory.items[0].weight).toBe(300); // 15 * 20
    expect(result.leftInventory.items[0].count).toBe(15);
  });

  it('should not remove source item when source is a shop', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, gridX: 0, gridY: 0 });
    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [] }),
      rightInventory: makeInventory({ id: 'shop-1', type: 'shop', items: [fromItem] }),
    });

    const result = reducer(state, gridMoveSlots({
      fromSlot: fromItem,
      fromType: 'shop',
      toType: 'player',
      toSlotId: 3,
      count: 10,
      toGridX: 0,
      toGridY: 0,
      rotated: false,
    }));

    // Shop source should keep its item
    expect(result.rightInventory.items).toHaveLength(1);
    expect(result.rightInventory.items[0].count).toBe(10);
    // Target should also have the item
    expect(result.leftInventory.items).toHaveLength(1);
    expect(result.leftInventory.items[0].count).toBe(10);
  });
});
