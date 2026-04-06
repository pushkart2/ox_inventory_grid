import { isSlotWithItem, getTotalWeight, isContainer } from '../../../web/src/helpers';
import { describe, it, expect } from 'vitest';

describe('isSlotWithItem', () => {
  it('should return true for a slot with name and weight', () => {
    expect(isSlotWithItem({ slot: 1, name: 'water', weight: 50 })).toBe(true);
  });

  it('should return false for a slot without name', () => {
    expect(isSlotWithItem({ slot: 1, weight: 50 })).toBe(false);
  });

  it('should return false for a slot without weight', () => {
    expect(isSlotWithItem({ slot: 1, name: 'water' })).toBe(false);
  });

  it('should return false for null/undefined', () => {
    expect(isSlotWithItem(null as any)).toBe(false);
    expect(isSlotWithItem(undefined as any)).toBe(false);
  });

  it('should return true in strict mode when name, count, and weight are present', () => {
    expect(isSlotWithItem({ slot: 1, name: 'water', count: 1, weight: 50 }, true)).toBe(true);
  });

  it('should still return true in strict mode with name and weight (non-strict path)', () => {
    // strict mode adds an OR condition, so name+weight still passes via the first branch
    expect(isSlotWithItem({ slot: 1, name: 'water', weight: 50 }, true)).toBe(true);
  });
});

describe('getTotalWeight', () => {
  it('should return 0 for empty items array', () => {
    expect(getTotalWeight([])).toBe(0);
  });

  it('should sum weights of slots with items and skip empty slots', () => {
    const items = [
      { slot: 1, name: 'water', count: 1, weight: 50 },
      { slot: 2 },
      { slot: 3, name: 'bread', count: 2, weight: 100 },
      { slot: 4 },
    ];
    expect(getTotalWeight(items)).toBe(150);
  });

  it('should return 0 when all slots are empty', () => {
    const items = [{ slot: 1 }, { slot: 2 }, { slot: 3 }];
    expect(getTotalWeight(items)).toBe(0);
  });
});

describe('isContainer', () => {
  it('should return true for container type inventory', () => {
    const inventory = { id: '1', type: 'container', slots: 10, items: [] };
    expect(isContainer(inventory)).toBe(true);
  });

  it('should return false for stash type inventory', () => {
    const inventory = { id: '1', type: 'stash', slots: 10, items: [] };
    expect(isContainer(inventory)).toBe(false);
  });

  it('should return false for player type inventory', () => {
    const inventory = { id: '1', type: 'player', slots: 50, items: [] };
    expect(isContainer(inventory)).toBe(false);
  });
});
