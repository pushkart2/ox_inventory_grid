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
const { swapSlots } = inventorySlice.actions;

describe('swapSlotsReducer', () => {
  it('should swap items across different inventories', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 3, weight: 300, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'bread', count: 1, weight: 150, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 3,
        items: [fromItem, makeSlot({ slot: 2 }), makeSlot({ slot: 3 })],
      }),
      rightInventory: makeInventory({
        id: 'stash-1',
        type: 'stash',
        slots: 3,
        items: [makeSlot({ slot: 1 }), toItem, makeSlot({ slot: 3 })],
      }),
    });

    const result = reducer(state, swapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
    }));

    // Source slot should now have the target item (bread) with source slot number
    expect(result.leftInventory.items[0].name).toBe('bread');
    expect(result.leftInventory.items[0].slot).toBe(1);
    expect(result.leftInventory.items[0].count).toBe(1);

    // Target slot should now have the source item (water) with target slot number
    expect(result.rightInventory.items[1].name).toBe('water');
    expect(result.rightInventory.items[1].slot).toBe(2);
    expect(result.rightInventory.items[1].count).toBe(3);
  });

  it('should swap items within the same inventory', () => {
    const itemA = makeItem({ slot: 1, name: 'water', count: 5, weight: 500, metadata: {} });
    const itemB = makeItem({ slot: 3, name: 'bread', count: 2, weight: 300, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 3,
        items: [itemA, makeSlot({ slot: 2 }), itemB],
      }),
    });

    const result = reducer(state, swapSlots({
      fromSlot: itemA,
      fromType: 'player',
      toSlot: itemB,
      toType: 'player',
    }));

    // Slot 1 should now have bread
    expect(result.leftInventory.items[0].name).toBe('bread');
    expect(result.leftInventory.items[0].slot).toBe(1);
    expect(result.leftInventory.items[0].count).toBe(2);

    // Slot 3 should now have water
    expect(result.leftInventory.items[2].name).toBe('water');
    expect(result.leftInventory.items[2].slot).toBe(3);
    expect(result.leftInventory.items[2].count).toBe(5);
  });

  it('should set durability to 100 on both swapped items', () => {
    const fromItem = makeItem({ slot: 1, name: 'water', count: 1, weight: 100, durability: 50, metadata: {} });
    const toItem = makeItem({ slot: 2, name: 'bread', count: 1, weight: 100, durability: 30, metadata: {} });

    const state = makeState({
      leftInventory: makeInventory({
        id: 'player',
        type: 'player',
        slots: 2,
        items: [fromItem, toItem],
      }),
    });

    const result = reducer(state, swapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'player',
    }));

    // Both items should have mocked durability (100)
    expect(result.leftInventory.items[0].durability).toBe(100);
    expect(result.leftInventory.items[1].durability).toBe(100);
  });

  it('should preserve item properties (count, weight) during swap', () => {
    const fromItem = makeItem({ slot: 1, name: 'ammo', count: 50, weight: 250, metadata: { type: 'pistol' } });
    const toItem = makeItem({ slot: 1, name: 'rifle_ammo', count: 30, weight: 600, metadata: { type: 'rifle' } });

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

    const result = reducer(state, swapSlots({
      fromSlot: fromItem,
      fromType: 'player',
      toSlot: toItem,
      toType: 'stash',
    }));

    // rifle_ammo should now be in player slot 1
    expect(result.leftInventory.items[0].name).toBe('rifle_ammo');
    expect(result.leftInventory.items[0].count).toBe(30);
    expect(result.leftInventory.items[0].weight).toBe(600);

    // ammo should now be in stash slot 1
    expect(result.rightInventory.items[0].name).toBe('ammo');
    expect(result.rightInventory.items[0].count).toBe(50);
    expect(result.rightInventory.items[0].weight).toBe(250);
  });
});
