# Review Log

This directory records per-paper review outcomes.

Each paper-note worker is responsible for:

- drafting exactly one note file;
- running Claude review for that note only;
- revising until no High/Medium actionable findings remain, up to 3 rounds;
- reporting the review result back to the controller.

The controller consolidates those results after each batch.

## Status meanings

- `Claude reviewed: Pass`: Claude review completed and returned no High/Medium actionable findings.
- `Local reviewed: Pass`: External Claude review was not available or not allowed; a subagent or controller completed strict local review with no known High/Medium findings.
- `Drafted, review pending`: Draft exists, but the required review pass has not completed.
