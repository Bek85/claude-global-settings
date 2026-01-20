# ASCII Diagram Patterns

Templates for visualizing code concepts.

## Flow Diagrams

### Linear Flow
```
[Input] --> [Process] --> [Output]
```

### Conditional Branch
```
        +---> [Yes Path] ---+
       /                     \
[Check]                       +--> [Continue]
       \                     /
        +---> [No Path] ----+
```

### Loop Structure
```
+-------+
|       v
|   [Process]
|       |
|   <Condition>
|       |
+--[Yes]+
        |
       [No]
        |
        v
    [Exit]
```

## Component Relationships

### Parent-Child
```
+------------------+
|     Parent       |
|  +----+  +----+  |
|  |Child| |Child| |
|  +----+  +----+  |
+------------------+
```

### Request-Response
```
Client          Server
  |    Request    |
  |-------------->|
  |               |
  |   Response    |
  |<--------------|
```

### Middleware Pipeline
```
Request --> [Auth] --> [Logger] --> [Handler] --> Response
```

## Data Flow

### State Update Cycle
```
+--------+    dispatch    +----------+
|  View  |--------------->|  Action  |
+--------+                +----------+
    ^                          |
    |                          v
+--------+    state       +----------+
|  Store |<---------------|  Reducer |
+--------+                +----------+
```

### Event Propagation
```
[Event Source]
      |
      v
[Event Bus/Emitter]
      |
   +--+--+
   |     |
   v     v
[Sub A] [Sub B]
```

## Architecture

### Layers
```
+-------------------+
|    Presentation   |  <-- UI Components
+-------------------+
|     Business      |  <-- Logic/Services
+-------------------+
|    Data Access    |  <-- Repository/API
+-------------------+
|    Database       |  <-- Storage
+-------------------+
```

### Microservices
```
[API Gateway]
      |
+-----+-----+
|     |     |
v     v     v
[A]  [B]  [C]  <-- Services
|     |     |
+-----+-----+
      |
      v
   [Message Queue]
```

## Data Structures

### Tree
```
        [Root]
       /      \
    [A]        [B]
   /   \         \
[A1]  [A2]       [B1]
```

### Linked List
```
[Head] --> [Node] --> [Node] --> [Tail] --> null
```

### Hash Table
```
Key    | Hash | Bucket
-------|------|--------
"foo"  |  2   | --> [value1]
"bar"  |  5   | --> [value2]
"baz"  |  2   | --> [value3] (collision)
```

## Usage Tips

1. **Keep it simple** - Use the minimum lines needed
2. **Label clearly** - Brief but descriptive labels
3. **Show direction** - Use arrows: `-->`, `<--`, `<-->`
4. **Box important items** - Use `[brackets]` or `+--+` boxes
5. **Align consistently** - Maintain visual alignment
