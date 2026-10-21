/**
 * Shared formatting helpers.
 */

/** '2026-01-30' -> '30 Jan 2026' (en-GB keeps day-first European convention). */
export function formatDate(date: Date): string {
  return date.toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  });
}
