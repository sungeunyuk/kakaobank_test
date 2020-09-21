


package net.oboki.kakaobank.recruit;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileReader;
import java.util.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import org.apache.commons.io.IOUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.Path;

import org.apache.parquet.column.ParquetProperties;
import org.apache.parquet.column.ParquetProperties.WriterVersion;
import org.apache.parquet.hadoop.api.WriteSupport;

import org.apache.avro.Schema;
import org.apache.parquet.schema.MessageType;
import org.apache.parquet.hadoop.metadata.CompressionCodecName;
import org.apache.parquet.hadoop.ParquetWriter;

import org.apache.parquet.avro.AvroSchemaConverter;
import org.apache.parquet.avro.AvroParquetWriter;





public class Test {

    static String result = null;
    static Connection conn = null;
    static Statement stmt = null;
    static PreparedStatement pstmt = null;
	
    static String source_table = null;

    static String inputPath = null;
    static String inputmsg = null;

    static String hdfsuri = "hdfs://bipa-name-t1001";


    public static void main(String[] argv)  {



// json read 
//
	JSONParser parser = new JSONParser();

	try {

		Object obj = parser.parse(new FileReader("/home1/irteamsu/codingtest-p4/resource/work.json"));  
		JSONObject jsonObj = (JSONObject)obj;

		System.out.println("작성자 :: " + jsonObj.get("작성자") );
		System.out.println("work   :: " + jsonObj.get("work") );


		JSONArray jsonArr = (JSONArray)jsonObj.get("work");
	
		JSONObject jsonItem = null; 

		for(int i=0; i<jsonArr.size(); i++){

                	jsonItem = (JSONObject)jsonArr.get(i);

                	System.out.println("job_anme     :: " +  jsonItem.get("job_name"));                
                	System.out.println("concurrency  :: " +  jsonItem.get("concurrency"));
                	System.out.println("source_table :: " +  jsonItem.get("source_table"));
                	System.out.println("target_table :: " +  jsonItem.get("target_table"));                
		
			// source_table 대상 테이블 		
			source_table = jsonItem.get("source_table").toString(); 
			System.out.println(source_table);
            	}           
	
	}catch (Exception e) {
           e.printStackTrace();
        }      



// json read end 






        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        try {
            conn = DriverManager.getConnection("jdbc:mysql://bipa-cmsrv-t1001:3306/KAKAOBANK?serverTimezone=UTC", "root", "dbrtjddms7!Q");

   	    System.out.println("드라이버 접속 성공!");

        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }


	try {
 		stmt =  conn.createStatement();
		String sql = "select * from ";
		String new_sql = sql + source_table;
                String where_sql = " where log_tktm like '%20190302%' ";
		ResultSet rs =   stmt.executeQuery(new_sql+where_sql);

	while( rs.next() ){

           System.out.println( rs.getString( 1 )+ " " + rs.getString(2) + rs.getString(3)+ rs.getString(4) ); // here 1 is tables 1st column
       }

	}catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                stmt.close();
                conn.close();
            } catch (SQLException e){
                e.printStackTrace();
            }
        }

    


  // mysql 로 읽어온 하루치 메뉴 로그를 
  // 방법 1. hive - parquet table 에 insert query 로 구축 하여 데이터 입력 
  // 방법 2. mysql 읽어온 데이터를 avro-parquet  파일로 떨구고 해당 파일을 
  //         hdfs 디렉토리에 hdfs write. 
  //
  //         방법 2 는 실패 하였고, 방법 1 테스트중 시간이 부족하여 완성하지 못했습니다. 





//            String driverName = "org.apache.hive.jdbc.HiveDriver";
//
  //              try { 
    //                    Class.forName(driverName);
      //          } catch (ClassNotFoundException ex) {
        //              ex.printStackTrace();
          //      }
 //
   //             System.out.println("before trying to connect");
     //           Connection con = DriverManager.getConnection("jdbc:hive2://bipa-hdpapp-t1002:10002/", "hive", "");
       //         System.out.println("connected");
 //
   //             Statement stmt = con.createStatement();
     //           stmt.executeQuery("show tables");
       //         //
         //       con.close();

// program end 

System.out.println("프로그램 exit ");

	}
} 
