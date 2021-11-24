package example;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Arrays;
import kotlin.collections.List;

fun main(args: Array<String>) {

  // Mongodb initialization parameters.
  val port_no :Int = 27017;
  val auth_user ="admin";
  val auth_pwd = "admin";
  val host_name = "db";
  val db_name = "test";
  var encoded_pwd = "";

  try {
      encoded_pwd = URLEncoder.encode(auth_pwd, "UTF-8");
  } catch (ex :UnsupportedEncodingException) {}

  // Mongodb connection string.
  val client_url = "mongodb://" + auth_user + ":" + encoded_pwd + "@" + host_name + ":" + port_no + "/" + db_name;
  val uri :MongoClientURI = MongoClientURI(client_url);

  // Connecting to the mongodb server using the given client uri.
  val mongo_client :MongoClient = MongoClient(uri);

  // Fetching the database from the mongodb.
  val db :MongoDatabase = mongo_client.getDatabase(db_name);

  val collection :MongoCollection<Document> = db.getCollection("employees");

//
// 4.2 Insert new document
//

  val employee :Document = Document()
                      .append("first_name", "Joe")
                      .append("last_name", "Smith")
                      .append("title", "Java Developer")
                      .append("years_of_service", 3)
                      .append("skills", Arrays.asList("java", "spring", "mongodb"))
                      .append("manager", Document()
                                            .append("first_name", "Sally")
                                            .append("last_name", "Johanson"));

  val employee2 :Document = Document()
                     .append("first_name", "Joe")
                     .append("last_name", "Friday")
                     .append("title", "Business Developer")
                     .append("years_of_service", 3)
                     .append("skills", Arrays.asList("social media", "spreadsheet"))
                     .append("manager", Document()
                                           .append("first_name", "Sally")
                                           .append("last_name", "Johanson"));

  val list = mutableListOf<Document>();
  list.add(employee);
  list.add(employee2);
  collection.insertMany(list);

  val query = Document("last_name", "Smith");
  queryResults(collection, query);

  db.listCollectionNames().forEach {
   println("[OUTPUT COLLECTION] " + it);
  }

  allResults(collection);

  println("[OUTPUT] Done")
}

///////////////////////////////////////////////////////
fun printResults(results :MutableList<Any>) {
  results.forEach {
   println("[OUTPUT RESULT] " + it.toString());
  }
}

///////////////////////////////////////////////////////
fun queryResults(collection :MongoCollection<Document>, query :Document) {
  val results = mutableListOf<Any>();
  collection.find(query).into(results);
  printResults(results);
}

///////////////////////////////////////////////////////
fun allResults(collection :MongoCollection<Document>) {
  val results = mutableListOf<Any>();
  collection.find().into(results);
  printResults(results);
}
