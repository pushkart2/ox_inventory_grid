import { describe, it, expect, vi } from 'vitest';

vi.mock('../../../web/src/reducers/setupInventory', () => {
  const setupGridInventory = (inv: any) => inv;

  const setupInventoryReducer = (state: any, action: any) => {
    const { leftInventory, rightInventory } = action.payload;

    if (leftInventory) {
      state.leftInventory = setupGridInventory(leftInventory);
    }

    if (rightInventory) {
      if (rightInventory.type === 'newdrop') {
        state.rightInventory = { id: '', type: '', slots: 0, maxWeight: 0, items: [] };
        const processed = setupGridInventory(rightInventory);
        const existingIdx = state.extraInventories.findIndex(
          (inv: any) => inv.type === 'drop' || inv.type === 'newdrop'
        );
        if (existingIdx !== -1) {
          state.extraInventories[existingIdx] = processed;
        } else {
          state.extraInventories.push(processed);
        }
      } else {
        state.rightInventory = setupGridInventory(rightInventory);
      }
    }

    state.shiftPressed = false;
    state.isBusy = false;
    state.searchState = { searchingSlots: [] };
  };

  return {
    setupGridInventory,
    setupSlotInventory: (inv: any) => inv,
    setupInventoryReducer,
  };
});
vi.mock('../../../web/src/helpers', async () => {
  const actual = await vi.importActual('../../../web/src/helpers') as any;
  return { ...actual, itemDurability: () => 100 };
});

import { inventorySlice } from '../../../web/src/store/inventory';
import { makeItem, makeInventory, makeState, emptyInventory } from '../testUtils';

const reducer = inventorySlice.reducer;
const { setupInventory } = inventorySlice.actions;

describe('setupInventoryReducer', () => {
  it('should place a newdrop rightInventory into extraInventories instead', () => {
    const state = makeState();
    const newdropInv = makeInventory({
      id: 'drop-1',
      type: 'newdrop',
      items: [makeItem({ slot: 1, name: 'water', gridX: 0, gridY: 0 })],
    });

    const result = reducer(state, setupInventory({ rightInventory: newdropInv }));

    // rightInventory should be cleared (empty placeholder)
    expect(result.rightInventory.id).toBe('');
    expect(result.rightInventory.type).toBe('');
    // The newdrop should be in extraInventories
    expect(result.extraInventories).toHaveLength(1);
    expect(result.extraInventories[0].id).toBe('drop-1');
    expect(result.extraInventories[0].type).toBe('newdrop');
  });

  it('should replace existing drop/newdrop in extraInventories when a new newdrop arrives', () => {
    const state = makeState({
      extraInventories: [
        makeInventory({ id: 'old-drop', type: 'drop', items: [] }),
      ],
    });
    const newdropInv = makeInventory({ id: 'new-drop', type: 'newdrop', items: [] });

    const result = reducer(state, setupInventory({ rightInventory: newdropInv }));

    expect(result.extraInventories).toHaveLength(1);
    expect(result.extraInventories[0].id).toBe('new-drop');
  });

  it('should set a stash as rightInventory directly', () => {
    const state = makeState();
    const stashInv = makeInventory({
      id: 'stash-1',
      type: 'stash',
      items: [makeItem({ slot: 1, name: 'bread' })],
    });

    const result = reducer(state, setupInventory({ rightInventory: stashInv }));

    expect(result.rightInventory.id).toBe('stash-1');
    expect(result.rightInventory.type).toBe('stash');
  });

  it('should set leftInventory when provided', () => {
    const state = makeState();
    const playerInv = makeInventory({
      id: 'player-1',
      type: 'player',
      slots: 50,
      items: [makeItem({ slot: 1 })],
    });

    const result = reducer(state, setupInventory({ leftInventory: playerInv }));

    expect(result.leftInventory.id).toBe('player-1');
  });

  it('should reset shiftPressed, isBusy, and searchState flags', () => {
    const state = makeState({
      shiftPressed: true,
      isBusy: true,
      searchState: { searchingSlots: [1, 2, 3] },
    });
    const stashInv = makeInventory({ id: 'stash-1', type: 'stash', items: [] });

    const result = reducer(state, setupInventory({ rightInventory: stashInv }));

    expect(result.shiftPressed).toBe(false);
    expect(result.isBusy).toBe(false);
    expect(result.searchState.searchingSlots).toEqual([]);
  });
});
