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
import { makeItem, makeSlot, makeInventory, makeState } from '../testUtils';

const reducer = inventorySlice.reducer;
const { stackSlots } = inventorySlice.actions;

describe('stackSlotsReducer', () => {
  it('should increase target count and weight when stacking', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'water', count: 5, weight: 500, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 3,
        items: [fromItem, toItem, makeSlot({ slot: 3 })],
      }),
    });

    const result = reducer(state, stackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
      count: 4,
    }));

    // pieceWeight = 1000/10 = 100
    // Target: 5 + 4 = 9, weight = 9 * 100 = 900
    expect(result.leftInventory.items[1].count).toBe(9);
    expect(result.leftInventory.items[1].weight).toBe(900);
  });

  it('should clear source slot when all items are stacked', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 3, weight: 300, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'water', count: 7, weight: 700, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 2,
        items: [fromItem, toItem],
      }),
    });

    const result = reducer(state, stackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
      count: 3,
    }));

    // Target: 7 + 3 = 10
    expect(result.leftInventory.items[1].count).toBe(10);
    expect(result.leftInventory.items[1].weight).toBe(1000);

    // Source should be emptied (slot only, no name)
    expect(result.leftInventory.items[0].name).toBeUndefined();
    expect(result.leftInventory.items[0].slot).toBe(1);
  });

  it('should leave remainder in source when partially stacking', () => {
    const fromItem = makeItem({ slot: 1, name: 'ammo', count: 20, weight: 400, metadata: {} });
    const toItem = makeItem({ slot: 3, name: 'ammo', count: 10, weight: 200, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 3,
        items: [fromItem, makeSlot({ slot: 2 }), toItem],
      }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 3,
        items: [makeSlot({ slot: 1 }), makeSlot({ slot: 2 }), makeSlot({ slot: 3 })],
      }),
    });

    const result = reducer(state, stackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
      count: 5,
    }));

    // pieceWeight = 400/20 = 20
    expect(result.leftInventory.items[2].count).toBe(15); // 10 + 5
    expect(result.leftInventory.items[2].weight).toBe(300); // 15 * 20
    expect(result.leftInventory.items[0].count).toBe(15); // 20 - 5
    expect(result.leftInventory.items[0].weight).toBe(300); // 15 * 20
  });

  it('should compute weight correctly across inventories', () => {
    const fromItem = makeItem({ slot: 1, name: 'food', count: 6, weight: 600, metadata: {} });
    const toItem = makeItem({ slot: 1, name: 'food', count: 4, weight: 400, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 2,
        items: [fromItem, makeSlot({ slot: 2 })],
      }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 2,
        items: [toItem, makeSlot({ slot: 2 })],
      }),
    });

    const result = reducer(state, stackSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
      count: 6,
    }));

    // pieceWeight = 600/6 = 100
    expect(result.rightInventory.items[0].count).toBe(10); // 4 + 6
    expect(result.rightInventory.items[0].weight).toBe(1000); // 10 * 100

    // Source should be emptied
    expect(result.leftInventory.items[0].name).toBeUndefined();
    expect(result.leftInventory.items[0].slot).toBe(1);
  });

  it('should not modify source when fromType is shop', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, metadata: {} });
    const toItem = makeItem({ slot: 1, name: 'water', count: 5, weight: 500, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 2,
        items: [toItem, makeSlot({ slot: 2 })],
      }),
      rightInventory: makeInventory({
        id: 'shop-1',
        type: 'shop',
        slots: 2,
        items: [fromItem, makeSlot({ slot: 2 })],
      }),
    });

    const result = reducer(state, stackSlots({
      fromSlot: fromItem,
      fromType: 'shop',
      toSlot: toItem,
      toType: 'player',
      count: 3,
    }));

    // Target should be updated
    expect(result.leftInventory.items[0].count).toBe(8); // 5 + 3
    // Shop source should remain unchanged
    expect(result.rightInventory.items[0].count).toBe(10);
    expect(result.rightInventory.items[0].name).toBe('water');
  });
});
