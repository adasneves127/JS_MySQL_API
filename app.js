//Import Fastify
const fastify = require('fastify')({
    logger: true
});

//Import MySql
const mysql = require('mysql');

//Default MySQL Connection
const mysqlAuthAcct = {
    host: 'localhost',
    user: 'AuthAccount',
    password: 'AuthAccount1!'
}

//Initialize MySQL Connection
var con = mysql.createConnection(mysqlAuthAcct);

//Connect to MySQL
con.connect((err) => {
    if (err) throw err;
    console.log("Connected to MySQL Server!");
})

//Default Error Handler
con.on('error', (err) => {
    console.log("Error: " + err.code);
})

//Routes;

//Post
// Authenticate User
fastify.post("/auth", (request, reply) => {
    //Get API Input values
    var username = request.body.username;
    var password = request.body.password;

    //Answer from MySQL saved as JSON
    var resultOutput = {};

    // Create our MySQL Query
    con.query(`SELECT * FROM API_Users.Users  WHERE \`username\` = '${username}' and \`password\`='${password}'`, function (err, result, fields){
        //If there is an error, don't throw, just send it back to the client
        if (err) {
            reply.send(err);
            return
        }
        else {
            //If there is no error, send the save the result to be processed.
            resultOutput = result;
        }

    //If we received a single result
    if (Object.keys(resultOutput).length === 1){
        //Output
        var response = {}
        //Get the token from the result
        var token = resultOutput.AuthKey;

        //If the token DNE
        if(!token){
            //Get a random 48 character token (Base 64)
            require('crypto').randomBytes(48, function(err, buffer) {
                //Get the token
                var token = buffer.toString('hex');
                
                //Create a query to insert the token into the database, under API_Users and Ecommerce Employees.
                con.query(`UPDATE API_Users.Users SET AuthKey = '${token}' where \`username\` = '${username}' AND \`password\`='${password}'`)
                con.query(`UPDATE Ecommerce.EMPLOYEES SET AuthKey = '${token}' where \`name\` = '${username}'`)

                //Send the token back to the client   
                response.token = token;
                reply.send(response);   
            });
        }  
        else{
            //If we already have a token for this client, send it back.
            var response = {}
            response.token = token;
            reply.send(response);
        }
                      
    }            
    else{
        //If no user found, send an error.
        reply.statusCode = 401;
        reply.send("No user found");
    }})
})

//Search for a customer
fastify.post("/Customers/Search", (request, reply) => {
    //JSON Layout:
    /*
    {
        "authKey": AUTH_KEY,
        "search": {
            "firstName": "",
            "lastName": "",
            "email": "",
            "phone": ""
            "country": "",
            "city": "",
            "state": "",
            "zip": "",
            "CustomerID": ""
        }
    }
    */

})

fastify.post("/Customers/Update", (req, res) => {

})

fastify.post("/Customers/Delete", (req, res) => {

})




fastify.listen({port: 3000}, (err, address) => {
    if(err){
        fastify.log.error(err);
        process.exit(1);
    }
})