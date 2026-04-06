import { itemDurability } from '../../../web/src/helpers';
import { describe, it, expect } from 'vitest';

describe('itemDurability', () => {
  it('should return undefined when metadata has no durability', () => {
    expect(itemDurability({}, 0)).toBeUndefined();
    expect(itemDurability({ label: 'test' }, 0)).toBeUndefined();
  });

  it('should return undefined when metadata is null or undefined', () => {
    expect(itemDurability(null, 0)).toBeUndefined();
    expect(itemDurability(undefined, 0)).toBeUndefined();
  });

  it('should return durability as-is when <= 100', () => {
    expect(itemDurability({ durability: 100 }, 0)).toBe(100);
    expect(itemDurability({ durability: 50 }, 0)).toBe(50);
    expect(itemDurability({ durability: 1 }, 0)).toBe(1);
  });

  it('should calculate percentage when durability > 100 and degrade is set', () => {
    // durability=200, curTime=100, degrade=1
    // ((200 - 100) / (60 * 1)) * 100 = (100/60)*100 = 166.67
    const result = itemDurability({ durability: 200, degrade: 1 }, 100);
    expect(result).toBeCloseTo((100 / 60) * 100, 2);
  });

  it('should return 0 when computed durability is negative', () => {
    // durability=101 (>100 triggers decay), curTime=200, degrade=1
    // ((101 - 200) / (60 * 1)) * 100 = (-99/60)*100 = -165 -> clamped to 0
    const result = itemDurability({ durability: 101, degrade: 1 }, 200);
    expect(result).toBe(0);
  });

  it('should return 0 for zero durability', () => {
    expect(itemDurability({ durability: 0 }, 0)).toBe(0);
  });

  it('should return negative durability as-is when <= 100 and no degrade (clamped to 0)', () => {
    // durability = -5, no degrade so the >100 branch is skipped, but <0 clamp triggers
    expect(itemDurability({ durability: -5 }, 0)).toBe(0);
  });

  it('should return durability > 100 as-is when degrade is not set', () => {
    // durability=150, no degrade => the >100 branch requires degrade, so it stays 150
    expect(itemDurability({ durability: 150 }, 0)).toBe(150);
  });
});
