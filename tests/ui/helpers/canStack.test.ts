import { canStack } from '../../../web/src/helpers';
import { describe, it, expect } from 'vitest';

describe('canStack', () => {
  it('should return true for same name and identical metadata', () => {
    const source = { slot: 1, name: 'water', metadata: { label: 'Fresh Water' } };
    const target = { slot: 2, name: 'water', metadata: { label: 'Fresh Water' } };
    expect(canStack(source, target)).toBe(true);
  });

  it('should return false for different names', () => {
    const source = { slot: 1, name: 'water', metadata: { label: 'Water' } };
    const target = { slot: 2, name: 'bread', metadata: { label: 'Water' } };
    expect(canStack(source, target)).toBe(false);
  });

  it('should return true when both have no metadata', () => {
    const source = { slot: 1, name: 'water' };
    const target = { slot: 2, name: 'water' };
    expect(canStack(source, target)).toBe(true);
  });

  it('should return false for different non-durability metadata', () => {
    const source = { slot: 1, name: 'water', metadata: { label: 'Fresh' } };
    const target = { slot: 2, name: 'water', metadata: { label: 'Stale' } };
    expect(canStack(source, target)).toBe(false);
  });

  it('should return true when only durability differs', () => {
    const source = { slot: 1, name: 'weapon_pistol', metadata: { durability: 80, serial: 'ABC' } };
    const target = { slot: 2, name: 'weapon_pistol', metadata: { durability: 50, serial: 'ABC' } };
    expect(canStack(source, target)).toBe(true);
  });

  it('should return false when only source has durability in metadata', () => {
    const source = { slot: 1, name: 'water', metadata: { durability: 80 } };
    const target = { slot: 2, name: 'water', metadata: {} };
    expect(canStack(source, target)).toBe(false);
  });

  it('should return false when only target has durability in metadata', () => {
    const source = { slot: 1, name: 'water', metadata: {} };
    const target = { slot: 2, name: 'water', metadata: { durability: 80 } };
    expect(canStack(source, target)).toBe(false);
  });

  it('should return false when durability differs and other metadata also differs', () => {
    const source = { slot: 1, name: 'weapon_pistol', metadata: { durability: 80, serial: 'ABC' } };
    const target = { slot: 2, name: 'weapon_pistol', metadata: { durability: 50, serial: 'XYZ' } };
    expect(canStack(source, target)).toBe(false);
  });

  it('should return true when both have empty metadata objects', () => {
    const source = { slot: 1, name: 'water', metadata: {} };
    const target = { slot: 2, name: 'water', metadata: {} };
    expect(canStack(source, target)).toBe(true);
  });
});
