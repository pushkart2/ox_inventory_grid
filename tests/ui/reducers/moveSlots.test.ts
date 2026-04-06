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
const { moveSlots } = inventorySlice.actions;

describe('moveSlotsReducer', () => {
  it('should fully move an item to an empty target slot', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 5, weight: 500, metadata: {} });
    const emptySlot = makeSlot({ slot: 3 });

    // Slot-based inventories use index = slot - 1
    const items = [fromItem, makeSlot({ slot: 2 }), emptySlot];

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', slots: 3, items }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 3,
        items: [makeSlot({ slot: 1 }), makeSlot({ slot: 2 }), makeSlot({ slot: 3 })],
      }),
    });

    const result = reducer(state, moveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: { slot: 2 },
      toType: 'stash',
      count: 5,
    }));

    // Target slot should have the item
    expect(result.rightInventory.items[1].name).toBe('water');
    expect(result.rightInventory.items[1].count).toBe(5);
    expect(result.rightInventory.items[1].weight).toBe(500);
    expect(result.rightInventory.items[1].slot).toBe(2);

    // Source slot should be cleared (empty slot)
    expect(result.leftInventory.items[0].name).toBeUndefined();
    expect(result.leftInventory.items[0].slot).toBe(1);
  });

  it('should partially move an item, leaving remainder in source', () => {
    const fromItem = makeItem({ slot: 1, name: 'ammo', count: 20, weight: 400, metadata: {} });
    const items = [fromItem];

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', slots: 5, items }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 5,
        items: [makeSlot({ slot: 1 }), makeSlot({ slot: 2 }), makeSlot({ slot: 3 }), makeSlot({ slot: 4 }), makeSlot({ slot: 5 })],
      }),
    });

    const result = reducer(state, moveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: { slot: 3 },
      toType: 'stash',
      count: 8,
    }));

    // pieceWeight = 400/20 = 20
    // Target should have 8 items
    expect(result.rightInventory.items[2].name).toBe('ammo');
    expect(result.rightInventory.items[2].count).toBe(8);
    expect(result.rightInventory.items[2].weight).toBe(160); // 8 * 20

    // Source should have remainder
    expect(result.leftInventory.items[0].count).toBe(12);
    expect(result.leftInventory.items[0].weight).toBe(240); // 12 * 20
  });

  it('should correctly compute weight from per-piece weight', () => {
    const fromItem = makeItem({ slot: 1, name: 'food', count: 4, weight: 1000, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({ id: 'player', type: 'player', slots: 2, items: [fromItem, makeSlot({ slot: 2 })] }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 2,
        items: [makeSlot({ slot: 1 }), makeSlot({ slot: 2 })],
      }),
    });

    const result = reducer(state, moveSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: { slot: 1 },
      toType: 'stash',
      count: 1,
    }));

    // pieceWeight = 1000/4 = 250
    expect(result.rightInventory.items[0].weight).toBe(250);
    expect(result.rightInventory.items[0].count).toBe(1);
    expect(result.leftInventory.items[0].count).toBe(3);
    expect(result.leftInventory.items[0].weight).toBe(750); // 3 * 250
  });

  it('should not modify source when fromType is shop', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 10, weight: 1000, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 3,
        items: [makeSlot({ slot: 1 }), makeSlot({ slot: 2 }), makeSlot({ slot: 3 })],
      }),
      rightInventory: makeInventory({ id: 'shop-1', type: 'shop', slots: 3, items: [fromItem, makeSlot({ slot: 2 }), makeSlot({ slot: 3 })] }),
    });

    const result = reducer(state, moveSlots({
      fromSlot: fromItem,
      fromType: 'shop',
      toSlot: { slot: 2 },
      toType: 'player',
      count: 10,
    }));

    // Target should have item
    expect(result.leftInventory.items[1].name).toBe('water');
    expect(result.leftInventory.items[1].count).toBe(10);

    // Shop source should remain unchanged
    expect(result.rightInventory.items[0].name).toBe('water');
    expect(result.rightInventory.items[0].count).toBe(10);
  });
});
