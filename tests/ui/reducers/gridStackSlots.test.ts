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
const { gridStackSlots } = inventorySlice.actions;

describe('gridStackSlotsReducer', () => {
  it('should partially stack items onto an existing stack', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, gridX: 0, gridY: 0 });
    const toItem = makeItem({ slot: 2, name: 'water', count: 5, weight: 500, gridX: 2, gridY: 2 });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [toItem] }),
    });

    const result = reducer(state, gridStackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
      count: 4,
    }));

    // Target should have increased count
    expect(result.rightInventory.items[0].count).toBe(9); // 5 + 4
    // pieceWeight = 1000/10 = 100
    expect(result.rightInventory.items[0].weight).toBe(900); // 9 * 100
    // Source should have decreased count
    expect(result.leftInventory.items[0].count).toBe(6); // 10 - 4
    expect(result.leftInventory.items[0].weight).toBe(600); // 6 * 100
  });

  it('should fully stack items and remove source slot', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 3, weight: 300, gridX: 0, gridY: 0 });
    const toItem = makeItem({ slot: 2, name: 'water', count: 7, weight: 700, gridX: 1, gridY: 1 });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem] }),
      rightInventory: makeInventory({ id: 'stash-1', type: 'stash', items: [toItem] }),
    });

    const result = reducer(state, gridStackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
      count: 3,
    }));

    // Target should have all items
    expect(result.rightInventory.items[0].count).toBe(10); // 7 + 3
    expect(result.rightInventory.items[0].weight).toBe(1000); // 10 * 100
    // Source item should be removed (spliced)
    expect(result.leftInventory.items).toHaveLength(0);
  });

  it('should correctly calculate weight with non-uniform piece weights', () => {
    const fromItem = makeItem({ slot: 1, name: 'ammo', count: 20, weight: 400, gridX: 0, gridY: 0 });
    const toItem = makeItem({ slot: 5, name: 'ammo', count: 10, weight: 200, gridX: 3, gridY: 0 });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [fromItem, toItem] }),
    });

    const result = reducer(state, gridStackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
      count: 8,
    }));

    // pieceWeight from source = 400/20 = 20
    const targetIdx = result.leftInventory.items.findIndex(i => i.slot === 5);
    expect(result.leftInventory.items[targetIdx].count).toBe(18); // 10 + 8
    expect(result.leftInventory.items[targetIdx].weight).toBe(360); // 18 * 20

    const sourceIdx = result.leftInventory.items.findIndex(i => i.slot === 1);
    expect(result.leftInventory.items[sourceIdx].count).toBe(12); // 20 - 8
    expect(result.leftInventory.items[sourceIdx].weight).toBe(240); // 12 * 20
  });

  it('should not remove source item when source is a shop', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 5, weight: 500, gridX: 0, gridY: 0 });
    const toItem = makeItem({ slot: 2, name: 'water', count: 3, weight: 300, gridX: 1, gridY: 0 });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', items: [toItem] }),
      rightInventory: makeInventory({ id: 'shop-1', type: 'shop', items: [fromItem] }),
    });

    const result = reducer(state, gridStackSlots({
      fromSlot: fromItem,
      fromType: 'shop',
      toSlot: toItem,
      toType: 'player',
      count: 5,
    }));

    // Target should have stacked items
    expect(result.leftInventory.items[0].count).toBe(8); // 3 + 5
    // Shop source should remain unchanged (no removal)
    expect(result.rightInventory.items).toHaveLength(1);
    expect(result.rightInventory.items[0].count).toBe(5);
  });
});
