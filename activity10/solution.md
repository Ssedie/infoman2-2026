# Activity 10 Solution


## Part 1: Quick Mapping (Postgres -> MongoDB)

| PostgreSQL | MongoDB Equivalent |
|---|---|
| `INSERT INTO posts ...` | `db.posts.insertOne({...})` |
| `SELECT * FROM posts WHERE title='...'` | `db.posts.find({title: "..."})` |
| `UPDATE posts SET title='...' WHERE id=...` | `db.posts.updateOne({_id: ...}, {$set: {title: "..."}})` |
| `DELETE FROM posts WHERE id=...` | `db.posts.deleteOne({_id: ...})` |

## Part 2: Hands-on CRUD in MongoDB

Write the commands you executed and paste screenshots from Mongo shell after each command/block.

### 2.1 Setup

Commands:

```javascript

use devstream_db
db.posts.drop()

db.posts.insertOne({
    _id: 1,
    title: "Mastering MongoDB",
    content: "Introduction",
    author_username: "db_zed",
    category: "database",
    views: 10
})

```

Screenshot(s):
- ![](/activity10/images/image.png)

### 2.2 Create

Commands:

```javascript

db.posts.insertOne({
  _id: 2,
  title: "Learning NoSQL Databases",
  content: "Basics of MongoDB",
  author_username: "student_user",
  category: "education",
  views: 5
})

```

Screenshot(s):
- ![](/activity10/images/image1.png)

### 2.3 Read

Commands:

```javascript
db.posts.find()

db.posts.find({ _id: 1 })

db.posts.find({}, { title: 1, author_username: 1, _id: 0 })
```

Screenshot(s):
- ![](/activity10/images/image2.png)
- ![](/activity10/images/image3.png)
- ![](/activity10/images/image4.png)

### 2.4 Update

Commands:

```javascript
db.posts.updateOne(
  { _id: 1 },
  { $set: { title: "MongoDB CRUD Basics" } }
)

db.posts.updateOne(
  { _id: 1 },
  { $inc: { views: 1 } }
)

db.posts.updateMany(
  {},
  { $set: { status: "published" } }
)
```

Screenshot(s):
- ![](/activity10/images/image5.png)
- ![](/activity10/images/image6.png)
- ![](/activity10/images/image7.png)
- ![](/activity10/images/image8.png)

### 2.5 Delete

Commands:

```javascript
db.posts.deleteOne({ _id: 2 })
```

Screenshot(s):
- ![](/activity10/images/image9.png)

## Part 3: Reflection (3-4 sentences)

1. One thing that feels easier in MongoDB CRUD:

[MongoDB CRUD feels easier when working with flexible data structures because you don’t need to define a strict schema before inserting data. It’s also simpler to add new fields like status without altering a table.]

2. One thing that was clearer in PostgreSQL CRUD:

[PostgreSQL CRUD is clearer when dealing with structured data and relationships because of its strict schema and use of SQL, which is more standardized and readable. Overall, MongoDB is more flexible, while PostgreSQL provides stronger structure and consistency.]

