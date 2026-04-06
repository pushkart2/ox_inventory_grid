import { findAvailableSlot } from '../../../web/src/helpers';
import { describe, it, expect } from 'vitest';

describe('findAvailableSlot', () => {
  it('should find an empty slot for non-stackable items', () => {
    const item = { slot: 1, name: 'key', count: 1, weight: 100 };
    const data = { name: 'key', label: 'Key', stack: false, usable: false, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'bread', count: 1, weight: 50 },
      { slot: 2 },
      { slot: 3, name: 'water', count: 1, weight: 50 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toEqual({ slot: 2 });
  });

  it('should return undefined for non-stackable items when no empty slot exists', () => {
    const item = { slot: 1, name: 'key', count: 1, weight: 100 };
    const data = { name: 'key', label: 'Key', stack: false, usable: false, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'bread', count: 1, weight: 50 },
      { slot: 2, name: 'water', count: 1, weight: 50 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toBeUndefined();
  });

  it('should find a matching stackable slot', () => {
    const item = { slot: 1, name: 'water', count: 1, weight: 50, metadata: { label: 'Water' } };
    const data = { name: 'water', label: 'Water', stack: true, usable: true, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'bread', count: 1, weight: 50 },
      { slot: 2, name: 'water', count: 3, weight: 150, metadata: { label: 'Water' } },
      { slot: 3 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toEqual(items[1]);
  });

  it('should skip stackable slot that is at stackSize', () => {
    const item = { slot: 1, name: 'ammo', count: 10, weight: 10 };
    const data = { name: 'ammo', label: 'Ammo', stack: true, stackSize: 50, usable: false, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'ammo', count: 50, weight: 500 },
      { slot: 2 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toEqual({ slot: 2 });
  });

  it('should match stackable items with different durability', () => {
    const item = { slot: 1, name: 'bandage', count: 1, weight: 20, metadata: { durability: 80, type: 'medical' } };
    const data = { name: 'bandage', label: 'Bandage', stack: true, usable: true, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'bandage', count: 2, weight: 40, metadata: { durability: 50, type: 'medical' } },
      { slot: 2 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toEqual(items[0]);
  });

  it('should return undefined when no stackable match and no empty slot', () => {
    const item = { slot: 1, name: 'water', count: 1, weight: 50, metadata: { label: 'Fresh' } };
    const data = { name: 'water', label: 'Water', stack: true, usable: true, close: false, count: 0 };
    const items = [
      { slot: 1, name: 'water', count: 3, weight: 150, metadata: { label: 'Stale' } },
      { slot: 2, name: 'bread', count: 1, weight: 50 },
    ];
    const result = findAvailableSlot(item, data, items);
    expect(result).toBeUndefined();
  });
});
