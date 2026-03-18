import Iter "mo:core/Iter";
import Map "mo:core/Map";
import Runtime "mo:core/Runtime";
import Array "mo:core/Array";
import Time "mo:core/Time";

actor {
  type LogEntry = {
    id : Nat;
    timestamp : Int;
    role : Text; // "pilot" or "ai"
    message : Text;
    flightPhase : Text;
  };

  type FlightSession = {
    id : Nat;
    startTime : Int;
    destination : Text;
    phase : Text;
    entries : [LogEntry];
  };

  public type FlightSessionSummary = {
    id : Nat;
    startTime : Int;
    destination : Text;
    phase : Text;
  };

  module FlightSessionSummary {
    public func fromFlightSession(session : FlightSession) : FlightSessionSummary {
      {
        id = session.id;
        startTime = session.startTime;
        destination = session.destination;
        phase = session.phase;
      };
    };
  };

  var nextSessionId = 1;
  var nextLogEntryId = 1;
  var currentSessionId : ?Nat = null;

  let sessions = Map.empty<Nat, FlightSession>();

  public shared ({ caller }) func startFlightSession(destination : Text, phase : Text) : async Nat {
    let sessionId = nextSessionId;
    nextSessionId += 1;

    let newSession : FlightSession = {
      id = sessionId;
      startTime = Time.now();
      destination;
      phase;
      entries = [];
    };

    sessions.add(sessionId, newSession);
    currentSessionId := ?sessionId;

    sessionId;
  };

  public shared ({ caller }) func addLogEntry(sessionId : Nat, role : Text, message : Text, flightPhase : Text) : async Nat {
    switch (sessions.get(sessionId)) {
      case (null) { Runtime.trap("Session not found") };
      case (?session) {
        let logEntryId = nextLogEntryId;
        nextLogEntryId += 1;

        let newEntry : LogEntry = {
          id = logEntryId;
          timestamp = Time.now();
          role;
          message;
          flightPhase;
        };

        let updatedEntries = session.entries.concat([newEntry]);
        let updatedSession : FlightSession = {
          id = session.id;
          startTime = session.startTime;
          destination = session.destination;
          phase = session.phase;
          entries = updatedEntries;
        };

        sessions.add(sessionId, updatedSession);
        logEntryId;
      };
    };
  };

  public query ({ caller }) func getLogEntries(sessionId : Nat) : async [LogEntry] {
    switch (sessions.get(sessionId)) {
      case (null) { Runtime.trap("Session not found") };
      case (?session) { session.entries };
    };
  };

  public query ({ caller }) func getFlightSessionSummaries() : async [FlightSessionSummary] {
    sessions.values().toArray().map(FlightSessionSummary.fromFlightSession);
  };

  public query ({ caller }) func getCurrentSession() : async ?FlightSession {
    switch (currentSessionId) {
      case (null) { return null };
      case (?id) { sessions.get(id) };
    };
  };

  public shared ({ caller }) func updateFlightPhase(sessionId : Nat, newPhase : Text) : async () {
    switch (sessions.get(sessionId)) {
      case (null) { Runtime.trap("Session not found") };
      case (?session) {
        let updatedSession : FlightSession = {
          id = session.id;
          startTime = session.startTime;
          destination = session.destination;
          phase = newPhase;
          entries = session.entries;
        };
        sessions.add(sessionId, updatedSession);
      };
    };
  };
};
