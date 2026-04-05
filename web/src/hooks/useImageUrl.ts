import { useEffect, useState } from 'react';

const imageCache = new Map<string, string>();

function validateImage(url: string): Promise<string> {
  if (imageCache.has(url)) return Promise.resolve(imageCache.get(url)!);

  return new Promise((resolve) => {
    const img = new Image();
    img.onload = () => {
      imageCache.set(url, url);
      resolve(url);
    };
    img.onerror = () => {
      const lowerUrl = url.replace(/\/([^/]+)$/, (match) => match.toLowerCase());
      if (lowerUrl !== url) {
        const img2 = new Image();
        img2.onload = () => {
          imageCache.set(url, lowerUrl);
          resolve(lowerUrl);
        };
        img2.onerror = () => {
          imageCache.set(url, '');
          resolve('');
        };
        img2.src = lowerUrl;
      } else {
        imageCache.set(url, '');
        resolve('');
      }
    };
    img.src = url;
  });
}

export function useImageUrl(rawUrl: string | undefined): string {
  const [validUrl, setValidUrl] = useState<string>(() => {
    if (!rawUrl) return 'none';
    const cached = imageCache.get(rawUrl);
    return cached !== undefined ? (cached || 'none') : rawUrl;
  });

  useEffect(() => {
    if (!rawUrl) {
      setValidUrl('none');
      return;
    }

    const cached = imageCache.get(rawUrl);
    if (cached !== undefined) {
      setValidUrl(cached || 'none');
      return;
    }

    validateImage(rawUrl).then((url) => {
      setValidUrl(url || 'none');
    });
  }, [rawUrl]);

  return validUrl;
}

export function handleImageError(e: React.SyntheticEvent<HTMLImageElement>) {
  const img = e.currentTarget;
  const src = img.src;
  const lowerSrc = src.replace(/\/([^/]+)$/, (match) => match.toLowerCase());

  if (lowerSrc !== src && !img.dataset.fallback) {
    img.dataset.fallback = '1';
    img.src = lowerSrc;
  }
}
