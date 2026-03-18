# AI Pilot Platform

## Current State
New project. Empty Motoko backend stub. No frontend code yet.

## Requested Changes (Diff)

### Add
- Full-stack AI Pilot Communication Platform
- Dark cockpit-themed dashboard UI
- Motoko backend: store decision log entries and flight session history
- Frontend: multi-panel cockpit dashboard with AI chat, flight data, alerts, and logs

### Modify
- N/A (new project)

### Remove
- N/A

## Implementation Plan

### Backend (Motoko)
- `LogEntry` type: id, timestamp, role ("pilot" | "ai"), message, flightPhase
- `FlightSession` type: id, startTime, destination, entries[]
- `startSession(destination: Text, phase: Text) -> SessionId`
- `addLogEntry(sessionId, role, message, phase) -> LogEntry`
- `getSessionLog(sessionId) -> [LogEntry]`
- `getAllSessions() -> [FlightSession]`
- `getLatestSession() -> ?FlightSession`

### Frontend
- **Layout**: Full-viewport dark dashboard, grid layout
  - Top bar: Mission Status Panel (flight phase selector, destination, weather)
  - Left column: Live Flight Data Panel (8 parameter inputs with gauges)
  - Center: Alert & Warning System (color-coded indicators)
  - Right column: AI Pilot Chat Interface
  - Bottom: AI Decision Log (scrollable history)
- **AI Decision Engine** (client-side TS):
  - Analyze flight parameters on change
  - Rules engine: altitude thresholds, EGT limits, fuel warnings, airspeed ranges
  - Generate contextual warnings and recommendations
  - Co-pilot voice style responses
- **Alert System**: Green/Yellow/Red status per parameter
- **Chat Interface**: Pilot input -> AI response with decision engine logic
- **Decision Log**: Timestamped history synced to backend
- **Theme**: Dark bg (#0a0e14), amber (#f59e0b) and neon green (#22c55e) accents, monospace font
