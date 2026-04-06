import { describe, it, expect } from 'vitest';
import { tooltipSlice, openTooltip, closeTooltip } from '../../../web/src/store/tooltip';
import { makeItem } from '../testUtils';

const reducer = tooltipSlice.reducer;

const initialState = () => ({
  open: false,
  item: null,
  inventoryType: null,
});

describe('tooltip store', () => {
  describe('openTooltip', () => {
    it('sets open to true, stores item and inventoryType', () => {
      const item = makeItem({ name: 'bandage', slot: 2 });
      const state = reducer(initialState(), openTooltip({ item, inventoryType: 'player' }));
      expect(state.open).toBe(true);
      expect(state.item).toEqual(item);
      expect(state.inventoryType).toBe('player');
    });
  });

  describe('closeTooltip', () => {
    it('sets open to false but preserves item/inventoryType', () => {
      const item = makeItem();
      let state = reducer(initialState(), openTooltip({ item, inventoryType: 'stash' }));
      state = reducer(state, closeTooltip());
      expect(state.open).toBe(false);
      expect(state.item).not.toBeNull();
      expect(state.inventoryType).toBe('stash');
    });

    it('works on already-closed state', () => {
      const state = reducer(initialState(), closeTooltip());
      expect(state.open).toBe(false);
    });
  });
});
