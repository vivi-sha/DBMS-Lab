db.createCollection("Student");
db.Student.insertMany([
{rollno:1,age:21,cont:9876,email:"anthara.de9@gmail.com"},
{rollno:2,a ge:22,cont:9976,email:"anushka.de9@gmail.com"},
{rollno:3,age:21,cont:5576,email:"anubhav.de9@gmail.com"},
{rollno:10,age:20,cont:2276,email:"rekha.de9@gmail.com"}]);

db.Student.update({rollno:5},{$set:{email:"abhinav@gmail.com"}})

db.Student.insert({rollno:11,age:22,name:"ABC",cont:2276,email:”rea.de9@gmail.com”});
db.Student.update({rollno:11,name:"ABC"},{$set:{name:"FEM"}})
