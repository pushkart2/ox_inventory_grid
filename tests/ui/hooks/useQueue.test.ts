import { describe, it, expect } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import useQueue from '../../../web/src/hooks/useQueue';

describe('useQueue', () => {
  it('starts empty by default', () => {
    const { result } = renderHook(() => useQueue<number>());

    expect(result.current.values).toEqual([]);
    expect(result.current.size).toBe(0);
    expect(result.current.first).toBeUndefined();
    expect(result.current.last).toBeUndefined();
  });

  it('initializes with provided values', () => {
    const { result } = renderHook(() => useQueue([10, 20, 30]));

    expect(result.current.values).toEqual([10, 20, 30]);
    expect(result.current.size).toBe(3);
    expect(result.current.first).toBe(10);
    expect(result.current.last).toBe(30);
  });

  it('enqueues items with add()', () => {
    const { result } = renderHook(() => useQueue<string>());

    act(() => {
      result.current.add('alpha');
    });

    expect(result.current.values).toEqual(['alpha']);
    expect(result.current.size).toBe(1);
    expect(result.current.first).toBe('alpha');
    expect(result.current.last).toBe('alpha');

    act(() => {
      result.current.add('beta');
    });

    expect(result.current.values).toEqual(['alpha', 'beta']);
    expect(result.current.size).toBe(2);
    expect(result.current.first).toBe('alpha');
    expect(result.current.last).toBe('beta');
  });

  it('dequeues items with remove() in FIFO order', () => {
    const { result } = renderHook(() => useQueue([1, 2, 3]));

    act(() => {
      result.current.remove();
    });

    expect(result.current.values).toEqual([2, 3]);
    expect(result.current.first).toBe(2);

    act(() => {
      result.current.remove();
    });

    expect(result.current.values).toEqual([3]);
  });

  it('returns undefined when removing from empty queue', () => {
    const { result } = renderHook(() => useQueue<number>());

    let removed: number | undefined;

    act(() => {
      removed = result.current.remove();
    });

    expect(removed).toBeUndefined();
    expect(result.current.values).toEqual([]);
  });

  it('peek via first does not modify the queue', () => {
    const { result } = renderHook(() => useQueue([100, 200]));

    const peeked = result.current.first;
    expect(peeked).toBe(100);
    expect(result.current.size).toBe(2);
  });

  it('clears the queue when all items are removed', () => {
    const { result } = renderHook(() => useQueue(['a', 'b']));

    act(() => {
      result.current.remove();
      result.current.remove();
    });

    expect(result.current.values).toEqual([]);
    expect(result.current.size).toBe(0);
    expect(result.current.first).toBeUndefined();
    expect(result.current.last).toBeUndefined();
  });
});
