import { describe, it, expect } from 'vitest';
import { contextMenuSlice, openContextMenu, closeContextMenu, setSplitAmount, clearSplit } from '../../../web/src/store/contextMenu';
import { makeItem } from '../testUtils';

const reducer = contextMenuSlice.reducer;

const initialState = () => ({
  coords: null,
  item: null,
  splitAmount: null,
});

describe('contextMenu store', () => {
  describe('openContextMenu', () => {
    it('sets splitAmount to item count when shiftKey is not pressed', () => {
      const item = makeItem({ count: 7 });
      const state = reducer(initialState(), openContextMenu({ item, coords: { x: 10, y: 20 } }));
      expect(state.splitAmount).toBe(7);
      expect(state.coords).toEqual({ x: 10, y: 20 });
      expect(state.item).toEqual(item);
    });

    it('sets splitAmount to half when shiftKey is pressed and count=10', () => {
      const item = makeItem({ count: 10 });
      const state = reducer(initialState(), openContextMenu({ item, coords: { x: 0, y: 0 }, shiftKey: true }));
      expect(state.splitAmount).toBe(5);
    });

    it('sets splitAmount to count when shiftKey is pressed but count=1', () => {
      const item = makeItem({ count: 1 });
      const state = reducer(initialState(), openContextMenu({ item, coords: { x: 0, y: 0 }, shiftKey: true }));
      expect(state.splitAmount).toBe(1);
    });

    it('floors the half value for odd counts (count=3 -> 1)', () => {
      const item = makeItem({ count: 3 });
      const state = reducer(initialState(), openContextMenu({ item, coords: { x: 5, y: 5 }, shiftKey: true }));
      expect(state.splitAmount).toBe(1);
    });

    it('sets coords and item', () => {
      const item = makeItem({ name: 'bread', slot: 3 });
      const state = reducer(initialState(), openContextMenu({ item, coords: { x: 100, y: 200 } }));
      expect(state.coords).toEqual({ x: 100, y: 200 });
      expect(state.item!.name).toBe('bread');
      expect(state.item!.slot).toBe(3);
    });
  });

  describe('closeContextMenu', () => {
    it('sets coords to null', () => {
      const item = makeItem();
      const opened = reducer(initialState(), openContextMenu({ item, coords: { x: 1, y: 1 } }));
      const state = reducer(opened, closeContextMenu());
      expect(state.coords).toBeNull();
      // item and splitAmount remain
      expect(state.item).not.toBeNull();
      expect(state.splitAmount).not.toBeNull();
    });
  });

  describe('setSplitAmount', () => {
    it('updates splitAmount', () => {
      const state = reducer(initialState(), setSplitAmount(42));
      expect(state.splitAmount).toBe(42);
    });
  });

  describe('clearSplit', () => {
    it('resets coords, item, and splitAmount to null', () => {
      const item = makeItem({ count: 5 });
      let state = reducer(initialState(), openContextMenu({ item, coords: { x: 1, y: 1 } }));
      state = reducer(state, clearSplit());
      expect(state.coords).toBeNull();
      expect(state.item).toBeNull();
      expect(state.splitAmount).toBeNull();
    });
  });
});
