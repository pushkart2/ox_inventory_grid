import { getTargetInventory } from '../../../web/src/helpers';
import { describe, it, expect } from 'vitest';
import type { State, Inventory } from '../../../web/src/typings';

const makeInventory = (id: string, type: string): Inventory => ({
  id,
  type,
  slots: 50,
  items: [],
});

const makeState = (): State => ({
  leftInventory: makeInventory('player-1', 'player'),
  rightInventory: makeInventory('trunk-1', 'trunk'),
  backpackInventory: makeInventory('backpack-1', 'backpack'),
  clothingInventory: makeInventory('clothing-1', 'clothing'),
  extraInventories: [
    makeInventory('extra-1', 'stash'),
    makeInventory('extra-2', 'container'),
  ],
  itemAmount: 0,
  shiftPressed: false,
  isBusy: false,
  additionalMetadata: [],
  dragRotated: false,
  hotbar: [],
  craftQueue: [],
  craftQueueProcessing: false,
  searchState: { searchingSlots: [] },
});

describe('getTargetInventory', () => {
  it('should resolve player type to leftInventory', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player', 'player');
    expect(result.sourceInventory).toBe(state.leftInventory);
    expect(result.targetInventory).toBe(state.leftInventory);
  });

  it('should resolve backpack type to backpackInventory', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player', 'backpack');
    expect(result.targetInventory).toBe(state.backpackInventory);
  });

  it('should resolve clothing type to clothingInventory', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player', 'clothing');
    expect(result.targetInventory).toBe(state.clothingInventory);
  });

  it('should resolve extra inventory by id', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player', 'stash', undefined, 'extra-2');
    expect(result.targetInventory).toBe(state.extraInventories[1]);
  });

  it('should fall back to rightInventory for unknown type without matching id', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player', 'stash', undefined, 'nonexistent');
    expect(result.targetInventory).toBe(state.rightInventory);
  });

  it('should default target to rightInventory when source is player and no targetType', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'player');
    expect(result.sourceInventory).toBe(state.leftInventory);
    expect(result.targetInventory).toBe(state.rightInventory);
  });

  it('should default target to leftInventory when source is not player and no targetType', () => {
    const state = makeState();
    const result = getTargetInventory(state, 'trunk');
    expect(result.sourceInventory).toBe(state.rightInventory);
    expect(result.targetInventory).toBe(state.leftInventory);
  });
});
