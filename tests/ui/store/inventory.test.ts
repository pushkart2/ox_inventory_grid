import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock setupInventory reducers before importing the slice
vi.mock('../../../web/src/reducers/setupInventory', () => ({
  setupGridInventory: (inv: any) => inv,
  setupSlotInventory: (inv: any) => inv,
  setupInventoryReducer: (state: any) => state,
}));

vi.mock('../../../web/src/reducers', () => ({
  moveSlotsReducer: (state: any) => state,
  refreshSlotsReducer: (state: any) => state,
  setupInventoryReducer: (state: any) => state,
  stackSlotsReducer: (state: any) => state,
  swapSlotsReducer: (state: any) => state,
  gridMoveSlotsReducer: (state: any) => state,
  gridSwapSlotsReducer: (state: any) => state,
  gridStackSlotsReducer: (state: any) => state,
}));

import { inventorySlice } from '../../../web/src/store/inventory';
import { makeItem, makeInventory, makeState } from '../testUtils';

const reducer = inventorySlice.reducer;

function freshState() {
  return makeState();
}

describe('inventory store', () => {
  // ---------- extraInventories ----------
  describe('addExtraInventory', () => {
    it('pushes a new non-drop inventory', () => {
      const state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'stash1', type: 'stash' })
      ));
      expect(state.extraInventories).toHaveLength(1);
      expect(state.extraInventories[0].id).toBe('stash1');
    });

    it('skips duplicate ids', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'stash1', type: 'stash' })
      ));
      state = reducer(state, inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'stash1', type: 'stash' })
      ));
      expect(state.extraInventories).toHaveLength(1);
    });

    it('replaces existing drop when adding newdrop', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'drop1', type: 'drop' })
      ));
      expect(state.extraInventories).toHaveLength(1);
      state = reducer(state, inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'newdrop1', type: 'newdrop' })
      ));
      expect(state.extraInventories).toHaveLength(1);
      expect(state.extraInventories[0].id).toBe('newdrop1');
      expect(state.extraInventories[0].type).toBe('newdrop');
    });

    it('replaces existing newdrop when adding drop', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'newdrop1', type: 'newdrop' })
      ));
      state = reducer(state, inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'drop2', type: 'drop' })
      ));
      expect(state.extraInventories).toHaveLength(1);
      expect(state.extraInventories[0].id).toBe('drop2');
      expect(state.extraInventories[0].type).toBe('drop');
    });

    it('pushes non-drop inventory alongside existing drop', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'drop1', type: 'drop' })
      ));
      state = reducer(state, inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'stash1', type: 'stash' })
      ));
      expect(state.extraInventories).toHaveLength(2);
    });
  });

  describe('removeExtraInventory', () => {
    it('removes by id', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'a', type: 'stash' })
      ));
      state = reducer(state, inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'b', type: 'stash' })
      ));
      state = reducer(state, inventorySlice.actions.removeExtraInventory('a'));
      expect(state.extraInventories).toHaveLength(1);
      expect(state.extraInventories[0].id).toBe('b');
    });
  });

  describe('clearExtraInventories', () => {
    it('empties the array', () => {
      let state = reducer(freshState(), inventorySlice.actions.addExtraInventory(
        makeInventory({ id: 'a', type: 'stash' })
      ));
      state = reducer(state, inventorySlice.actions.clearExtraInventories());
      expect(state.extraInventories).toHaveLength(0);
    });
  });

  // ---------- removePlayerItem ----------
  describe('removePlayerItem', () => {
    it('removes item from leftInventory by slot', () => {
      const state = reducer(
        makeState({
          leftInventory: makeInventory({
            id: 'player',
            type: 'player',
            items: [makeItem({ slot: 1 }), makeItem({ slot: 2, name: 'bread' })],
          }),
        }),
        inventorySlice.actions.removePlayerItem(1)
      );
      expect(state.leftInventory.items).toHaveLength(1);
      expect(state.leftInventory.items[0].slot).toBe(2);
    });
  });

  // ---------- removeBackpackItem ----------
  describe('removeBackpackItem', () => {
    it('removes item from backpackInventory by slot', () => {
      const state = reducer(
        makeState({
          backpackInventory: makeInventory({
            id: 'bp',
            type: 'backpack',
            items: [makeItem({ slot: 5 }), makeItem({ slot: 6 })],
          }),
        }),
        inventorySlice.actions.removeBackpackItem(5)
      );
      expect(state.backpackInventory.items).toHaveLength(1);
      expect(state.backpackInventory.items[0].slot).toBe(6);
    });
  });

  // ---------- hotbar ----------
  describe('assignHotbar', () => {
    it('assigns an item slot to a hotbar slot', () => {
      const state = reducer(freshState(), inventorySlice.actions.assignHotbar({ hotbarSlot: 0, itemSlot: 3 }));
      expect(state.hotbar[0]).toBe(3);
    });

    it('clears previous hotbar reference when same itemSlot is re-assigned', () => {
      let state = reducer(freshState(), inventorySlice.actions.assignHotbar({ hotbarSlot: 0, itemSlot: 3 }));
      state = reducer(state, inventorySlice.actions.assignHotbar({ hotbarSlot: 2, itemSlot: 3 }));
      expect(state.hotbar[0]).toBeNull();
      expect(state.hotbar[2]).toBe(3);
    });

    it('ignores out-of-range hotbarSlot', () => {
      const state = reducer(freshState(), inventorySlice.actions.assignHotbar({ hotbarSlot: 5, itemSlot: 1 }));
      expect(state.hotbar).toEqual([null, null, null, null, null]);
    });
  });

  describe('clearHotbar', () => {
    it('clears a specific hotbar slot', () => {
      let state = reducer(freshState(), inventorySlice.actions.assignHotbar({ hotbarSlot: 1, itemSlot: 7 }));
      state = reducer(state, inventorySlice.actions.clearHotbar(1));
      expect(state.hotbar[1]).toBeNull();
    });

    it('ignores out-of-range slot', () => {
      const state = reducer(freshState(), inventorySlice.actions.clearHotbar(9));
      expect(state.hotbar).toEqual([null, null, null, null, null]);
    });
  });

  describe('restoreHotbar', () => {
    it('replaces the entire hotbar array', () => {
      const newHotbar = [1, null, 3, null, 5] as (number | null)[];
      const state = reducer(freshState(), inventorySlice.actions.restoreHotbar(newHotbar));
      expect(state.hotbar).toEqual([1, null, 3, null, 5]);
    });
  });

  // ---------- drag rotation ----------
  describe('toggleDragRotation', () => {
    it('flips dragRotated', () => {
      let state = reducer(freshState(), inventorySlice.actions.toggleDragRotation());
      expect(state.dragRotated).toBe(true);
      state = reducer(state, inventorySlice.actions.toggleDragRotation());
      expect(state.dragRotated).toBe(false);
    });
  });

  describe('setDragRotated', () => {
    it('sets dragRotated to the given value', () => {
      const state = reducer(freshState(), inventorySlice.actions.setDragRotated(true));
      expect(state.dragRotated).toBe(true);
      const state2 = reducer(state, inventorySlice.actions.setDragRotated(false));
      expect(state2.dragRotated).toBe(false);
    });
  });

  // ---------- craft queue ----------
  describe('addToCraftQueue', () => {
    it('adds a new craft queue entry', () => {
      const state = reducer(freshState(), inventorySlice.actions.addToCraftQueue({
        recipeSlot: 0,
        itemName: 'bandage',
        label: 'Bandage',
        duration: 5000,
        count: 3,
      }));
      expect(state.craftQueue).toHaveLength(1);
      expect(state.craftQueue[0].itemName).toBe('bandage');
      expect(state.craftQueue[0].totalCount).toBe(3);
      expect(state.craftQueue[0].completedCount).toBe(0);
      expect(state.craftQueue[0].status).toBe('queued');
    });

    it('increments totalCount for existing queue entry with same recipeSlot', () => {
      let state = reducer(freshState(), inventorySlice.actions.addToCraftQueue({
        recipeSlot: 0,
        itemName: 'bandage',
        label: 'Bandage',
        duration: 5000,
        count: 3,
      }));
      state = reducer(state, inventorySlice.actions.addToCraftQueue({
        recipeSlot: 0,
        itemName: 'bandage',
        label: 'Bandage',
        duration: 5000,
        count: 2,
      }));
      expect(state.craftQueue).toHaveLength(1);
      expect(state.craftQueue[0].totalCount).toBe(5);
    });
  });

  describe('removeCraftQueueItem', () => {
    it('removes by queueId', () => {
      let state = reducer(freshState(), inventorySlice.actions.addToCraftQueue({
        recipeSlot: 0,
        itemName: 'bandage',
        label: 'Bandage',
        duration: 5000,
        count: 1,
      }));
      const queueId = state.craftQueue[0].queueId;
      state = reducer(state, inventorySlice.actions.removeCraftQueueItem(queueId));
      expect(state.craftQueue).toHaveLength(0);
    });
  });

  describe('clearCraftQueue', () => {
    it('empties craftQueue and resets processing flag', () => {
      let state = reducer(freshState(), inventorySlice.actions.addToCraftQueue({
        recipeSlot: 0,
        itemName: 'bandage',
        label: 'Bandage',
        duration: 5000,
        count: 1,
      }));
      state = reducer(state, inventorySlice.actions.setCraftQueueProcessing(true));
      state = reducer(state, inventorySlice.actions.clearCraftQueue());
      expect(state.craftQueue).toHaveLength(0);
      expect(state.craftQueueProcessing).toBe(false);
    });
  });

  // ---------- search ----------
  describe('beginItemSearch', () => {
    it('adds slot to searchingSlots', () => {
      const state = reducer(freshState(), inventorySlice.actions.beginItemSearch(5));
      expect(state.searchState.searchingSlots).toContain(5);
    });

    it('does not add duplicate slots', () => {
      let state = reducer(freshState(), inventorySlice.actions.beginItemSearch(5));
      state = reducer(state, inventorySlice.actions.beginItemSearch(5));
      expect(state.searchState.searchingSlots).toEqual([5]);
    });
  });

  describe('finishItemSearch', () => {
    it('removes slot from searchingSlots and marks item as searched', () => {
      const rightItem = makeItem({ slot: 3, name: 'loot' });
      let state = makeState({
        rightInventory: makeInventory({ id: 'right', type: 'drop', items: [rightItem] }),
        searchState: { searchingSlots: [3] },
      });
      state = reducer(state, inventorySlice.actions.finishItemSearch(3));
      expect(state.searchState.searchingSlots).not.toContain(3);
      const item = state.rightInventory.items.find((i: any) => i.slot === 3);
      expect(item?.searched).toBe(true);
    });
  });

  // ---------- itemAmount / shiftPressed ----------
  describe('setItemAmount', () => {
    it('sets itemAmount', () => {
      const state = reducer(freshState(), inventorySlice.actions.setItemAmount(42));
      expect(state.itemAmount).toBe(42);
    });
  });

  describe('setShiftPressed', () => {
    it('sets shiftPressed', () => {
      const state = reducer(freshState(), inventorySlice.actions.setShiftPressed(true));
      expect(state.shiftPressed).toBe(true);
    });
  });
});
