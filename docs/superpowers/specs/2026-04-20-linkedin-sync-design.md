# LinkedIn Experience Comparison and Sync Design

## Problem

The resume site already uses `_data\data.yml` as its content source of truth, but LinkedIn job experience can drift from that data over time. The goal is to update resume content in one place and then generate clear, repeatable guidance for bringing LinkedIn job experience back into sync.

## Goals

- Keep `_data\data.yml` as the single editable source of truth.
- Compare resume experience data against a local snapshot of LinkedIn experience data.
- Generate human-readable output that shows mismatches and provides LinkedIn-ready update text.
- Focus the first version on professional experience only.

## Non-Goals

- Direct API-based LinkedIn profile reads or writes.
- Browser automation against the LinkedIn website.
- Full-profile synchronization outside job experience in the initial version.

## Constraints

- Self-serve LinkedIn API access is not sufficient for reading or updating detailed job experience.
- The comparison workflow must work locally without depending on fragile web automation.
- Generated artifacts should be reproducible and should not become hand-edited sources of truth.

## Proposed Approach

Use two local structured inputs:

1. `_data\data.yml` as the canonical resume source.
2. A new LinkedIn snapshot file, such as `_data\linkedin-experience.yml`, containing normalized experience data copied or exported from LinkedIn.

Add a script that reads both files, normalizes their experience records into a shared internal shape, compares them, and produces:

- `linkedin-diff.md`: a mismatch report
- `linkedin-update.md`: LinkedIn-ready, pasteable experience text derived from the canonical resume data

This makes the repository the only place where content is authored while turning LinkedIn into a downstream synchronization target.

## Architecture

### Inputs

#### Canonical resume data

Continue using `_data\data.yml`, specifically the `experiences` collection, as the source of truth for job history.

#### LinkedIn snapshot data

Add a new file dedicated to the current LinkedIn state. The exact filename can be finalized during implementation, but it should live under `_data\` and be shaped to mirror the fields needed for comparison:

- company
- role
- location
- time
- highlights
- technologies

### Internal normalization layer

Before comparison, transform both sources into the same in-memory model:

- normalized company name
- normalized role
- normalized location
- normalized time range
- normalized bullet list
- normalized technologies list

Normalization should remove formatting-only noise such as repeated whitespace and minor punctuation differences. It should not silently rewrite substantive content.

### Comparison engine

Compare records using company, role, and time range as primary matching signals. The engine should classify differences into explicit categories:

- present in resume only
- present in LinkedIn only
- matched role with metadata differences
- matched role with highlight differences
- matched role with technology differences

If multiple records could match ambiguously, the script should fail clearly instead of guessing.

### Output generation

Generate two artifacts:

#### `linkedin-diff.md`

A readable report showing:

- missing roles
- extra roles
- changed titles
- changed date ranges
- changed locations
- changed highlight content

#### `linkedin-update.md`

A LinkedIn-oriented document generated from `_data\data.yml` that condenses each role into paste-ready content suitable for LinkedIn experience entries.

## Data Flow

1. Edit `_data\data.yml`.
2. Refresh the LinkedIn snapshot file from the current LinkedIn profile.
3. Run the comparison script.
4. Review `linkedin-diff.md`.
5. Copy from `linkedin-update.md` to update LinkedIn manually.

This preserves a one-way authorship flow: author in the repo, reconcile LinkedIn from generated output.

## Error Handling

The script should stop with explicit errors when:

- required fields are missing
- duplicate or ambiguous experience entries are found
- date ranges cannot be interpreted consistently
- the LinkedIn snapshot format does not match the expected schema

The script should not silently skip malformed records.

## Validation and Testing

Implementation should include validation for:

- required experience fields
- duplicate experience detection
- deterministic matching behavior
- normalization behavior for whitespace and punctuation-only differences

Testing should focus on comparison logic and output generation, especially for:

- exact matches
- missing LinkedIn roles
- changed dates or titles
- bullet differences
- ambiguous matches

## Implementation Notes

- Reuse the repository's current data-driven structure rather than introducing a second canonical system.
- Keep generated comparison artifacts separate from source files.
- Do not introduce `.env` or OAuth configuration in the first version because the approved design does not depend on LinkedIn API access.
- Scope the initial implementation to job experience. Additional sections such as summary, skills, or education can be added later if the experience workflow proves useful.

## Recommended Initial Deliverables

1. A LinkedIn snapshot file format under `_data\`.
2. A comparison/generation script.
3. Generated `linkedin-diff.md` and `linkedin-update.md` artifacts.
4. Documentation in `README.md` describing the comparison workflow.
