const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '1234',
  database: 'thai_dealy'
});

db.connect(err => {
  if (err) throw err;
  console.log('📡 MySQL Connected!');
});

// ฟังก์ชันช่วยแปลง ISO เป็น 'YYYY-MM-DD HH:MM:SS'
function toMySQLDatetime(isoString) {
  const date = new Date(isoString);
  return date.toISOString().slice(0, 19).replace('T', ' '); // แปลงวันที่ให้เป็นฟอร์แมตที่ MySQL ยอมรับ
}

// POST /notes → สำหรับเพิ่มโน้ตใหม่
app.post('/notes', (req, res) => {
  const data = req.body;
  console.log('📥 POST /notes received');
  console.log('📄 Body:', data);

  // ตรวจสอบค่าของ data
  if (Array.isArray(data)) {
    // ✅ รองรับ array หลายรายการ
    const sql = `
      INSERT INTO notes (title, created_by, last_modified, dateline, sent_for, contact, link_map, address, tel, description, status, company, category)
      VALUES ?
    `;
    const values = data.map(note => [
      note.title,
      note.created_by,
      toMySQLDatetime(note.last_modified),
      toMySQLDatetime(note.dateline),
      note.sent_for,
      note.contact,
      note.link_map,
      note.address,
      note.tel,
      note.description,
      note.status || 'Normal', // กำหนดสถานะเป็น 'Normal' ถ้าไม่มีการส่งค่า
      note.company || 'บริษัทA', // กำหนดบริษัทเป็น 'บริษัทA' ถ้าไม่มีการส่งค่า
      note.category || 'ติดตั้งเครื่อง' // กำหนดประเภทงานเป็น 'ติดตั้งเครื่อง' ถ้าไม่มีการส่งค่า
    ]);

    db.query(sql, [values], (err, result) => {
      if (err) {
        console.error('❌ Bulk insert error:', err);
        return res.status(500).json({ error: 'Bulk insert failed', detail: err.message });
      }
      res.status(201).json({ message: '✅ Multiple notes saved successfully' });
    });

  } else {
    // ✅ กรณี object เดียว
    const sql = `
      INSERT INTO notes (title, created_by, last_modified, dateline, sent_for, contact, link_map, address, tel, description, status, company, category)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const values = [
      data.title,
      data.created_by,
      toMySQLDatetime(data.last_modified),
      toMySQLDatetime(data.dateline),
      data.sent_for,
      data.contact,
      data.link_map,
      data.address,
      data.tel,
      data.description,
      data.status || 'Normal', // กำหนดสถานะเป็น 'Normal' ถ้าไม่มีการส่งค่า
      data.company || 'บริษัทA', // กำหนดบริษัทเป็น 'บริษัทA' ถ้าไม่มีการส่งค่า
      data.category || 'ติดตั้งเครื่อง' // กำหนดประเภทงานเป็น 'ติดตั้งเครื่อง' ถ้าไม่มีการส่งค่า
    ];

    db.query(sql, values, (err, result) => {
      if (err) {
        console.error('❌ Insert error:', err);
        return res.status(500).json({ error: 'Insert failed', detail: err.message });
      }
      res.status(201).json({ message: '✅ Note saved successfully' });
    });
  }
});


// ✅ ดึงข้อมูลทั้งหมดจากตาราง notes
app.get('/notes', (req, res) => {
  const sql = 'SELECT * FROM notes ORDER BY dateline DESC';

  db.query(sql, (err, results) => {
    if (err) {
      console.error('❌ Error fetching notes:', err);
      return res.status(500).json({ error: 'Failed to fetch notes' });
    }

    res.json(results); // ✅ ส่งข้อมูลกลับไปให้ Flutter/Postman
  });
});


// ✅ PUT /notes/:id → สำหรับ update โน้ต
app.put('/notes/:id', (req, res) => {
  const id = req.params.id;
  const data = req.body;

  const sql = `
    UPDATE notes SET
      title = ?,
      created_by = ?,
      last_modified = ?,
      dateline = ?,
      sent_for = ?,
      contact = ?,
      link_map = ?,
      address = ?,
      tel = ?,
      description = ?,
      status = ?,     -- เพิ่มการอัปเดตสถานะ
      company = ?,    -- เพิ่มการอัปเดตชื่อบริษัท
      category = ?    -- เพิ่มการอัปเดตประเภทงาน
    WHERE id = ?
  `;

  const values = [
    data.title,
    data.created_by,
    toMySQLDatetime(data.last_modified),
    toMySQLDatetime(data.dateline),
    data.sent_for,
    data.contact,
    data.link_map,
    data.address,
    data.tel,
    data.description,
    data.status,  // อัปเดตสถานะ
    data.company, // อัปเดตชื่อบริษัท
    data.category, // อัปเดตประเภทงาน
    id,
  ];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('❌ Update error:', err);
      return res.status(500).json({ error: 'Failed to update note' });
    }
    res.status(200).json({ message: '✅ Note updated successfully' });
  });
});

// ✅ DELETE /notes/:id → สำหรับลบโน้ต
app.delete('/notes/:id', (req, res) => {
  const noteId = req.params.id;
  const sql = 'DELETE FROM notes WHERE id = ?';

  db.query(sql, [noteId], (err, result) => {
    if (err) {
      console.error("❌ Delete error:", err);
      return res.status(500).json({ error: "Delete failed" });
    }
    res.json({ message: "🗑 Note deleted successfully" });
  });
});

app.listen(3000, () => {
  console.log('🚀 Server running at http://localhost:3000');
});
