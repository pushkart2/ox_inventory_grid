import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { renderHook, act, waitFor } from '@testing-library/react';
import { useImageUrl, handleImageError } from '../../../web/src/hooks/useImageUrl';

// We need to control the global Image class to simulate load/error in validateImage.
// Each test sets up its own mock behavior.

let imageInstances: Array<{ src: string; onload: (() => void) | null; onerror: (() => void) | null }>;

class MockImage {
  src = '';
  onload: (() => void) | null = null;
  onerror: (() => void) | null = null;

  constructor() {
    imageInstances.push(this as any);
  }
}

beforeEach(() => {
  imageInstances = [];
  vi.stubGlobal('Image', MockImage);
});

afterEach(() => {
  vi.restoreAllMocks();
});

describe('handleImageError', () => {
  it('sets lowercase src on first error', () => {
    const img = {
      src: 'http://example.com/items/WEAPON_Pistol.png',
      dataset: {} as Record<string, string>,
    } as unknown as HTMLImageElement;

    const event = { currentTarget: img } as unknown as React.SyntheticEvent<HTMLImageElement>;

    handleImageError(event);

    expect(img.src).toBe('http://example.com/items/weapon_pistol.png');
    expect(img.dataset.fallback).toBe('1');
  });

  it('does nothing if data-fallback is already set', () => {
    const img = {
      src: 'http://example.com/items/WEAPON_Pistol.png',
      dataset: { fallback: '1' } as Record<string, string>,
    } as unknown as HTMLImageElement;

    const event = { currentTarget: img } as unknown as React.SyntheticEvent<HTMLImageElement>;
    const originalSrc = img.src;

    handleImageError(event);

    expect(img.src).toBe(originalSrc);
  });

  it('does nothing if src is already lowercase', () => {
    const img = {
      src: 'http://example.com/items/weapon_pistol.png',
      dataset: {} as Record<string, string>,
    } as unknown as HTMLImageElement;

    const event = { currentTarget: img } as unknown as React.SyntheticEvent<HTMLImageElement>;

    handleImageError(event);

    // src unchanged because lowercase version equals original
    expect(img.src).toBe('http://example.com/items/weapon_pistol.png');
    expect(img.dataset.fallback).toBeUndefined();
  });
});

describe('useImageUrl', () => {
  it('returns "none" when rawUrl is undefined', () => {
    const { result } = renderHook(() => useImageUrl(undefined));
    expect(result.current).toBe('none');
  });

  it('returns the original url on successful image load', async () => {
    const url = 'http://example.com/items/pistol.png';

    const { result } = renderHook(() => useImageUrl(url));

    // validateImage creates an Image and sets src; trigger onload
    await waitFor(() => {
      expect(imageInstances.length).toBeGreaterThanOrEqual(1);
    });

    act(() => {
      const img = imageInstances[0];
      img.onload?.();
    });

    await waitFor(() => {
      expect(result.current).toBe(url);
    });
  });

  it('returns lowercase url when original fails but lowercase succeeds', async () => {
    const url = 'http://example.com/items/PISTOL.png';

    const { result } = renderHook(() => useImageUrl(url));

    await waitFor(() => {
      expect(imageInstances.length).toBeGreaterThanOrEqual(1);
    });

    // First image fails
    act(() => {
      imageInstances[0].onerror?.();
    });

    // Second image (lowercase attempt) succeeds
    await waitFor(() => {
      expect(imageInstances.length).toBeGreaterThanOrEqual(2);
    });

    act(() => {
      imageInstances[1].onload?.();
    });

    await waitFor(() => {
      expect(result.current).toBe('http://example.com/items/pistol.png');
    });
  });

  it('returns "none" when both original and lowercase fail', async () => {
    const url = 'http://example.com/items/SHOTGUN_FAIL.png';

    const { result } = renderHook(() => useImageUrl(url));

    await waitFor(() => {
      expect(imageInstances.length).toBeGreaterThanOrEqual(1);
    });

    act(() => {
      imageInstances[0].onerror?.();
    });

    await waitFor(() => {
      expect(imageInstances.length).toBeGreaterThanOrEqual(2);
    });

    act(() => {
      imageInstances[1].onerror?.();
    });

    await waitFor(() => {
      expect(result.current).toBe('none');
    });
  });
});
