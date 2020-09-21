// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Mon Sep 21 21:30:50 KST 2020
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import org.apache.sqoop.lib.JdbcWritableBridge;
import org.apache.sqoop.lib.DelimiterSet;
import org.apache.sqoop.lib.FieldFormatter;
import org.apache.sqoop.lib.RecordParser;
import org.apache.sqoop.lib.BooleanParser;
import org.apache.sqoop.lib.BlobRef;
import org.apache.sqoop.lib.ClobRef;
import org.apache.sqoop.lib.LargeObjectLoader;
import org.apache.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  public static interface FieldSetterCommand {    void setField(Object value);  }  protected ResultSet __cur_result_set;
  private Map<String, FieldSetterCommand> setters = new HashMap<String, FieldSetterCommand>();
  private void init0() {
    setters.put("LOG_TKTM", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        QueryResult.this.LOG_TKTM = (String)value;
      }
    });
    setters.put("LOG_ID", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        QueryResult.this.LOG_ID = (String)value;
      }
    });
    setters.put("USR_NO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        QueryResult.this.USR_NO = (String)value;
      }
    });
    setters.put("MENU_NM", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        QueryResult.this.MENU_NM = (String)value;
      }
    });
  }
  public QueryResult() {
    init0();
  }
  private String LOG_TKTM;
  public String get_LOG_TKTM() {
    return LOG_TKTM;
  }
  public void set_LOG_TKTM(String LOG_TKTM) {
    this.LOG_TKTM = LOG_TKTM;
  }
  public QueryResult with_LOG_TKTM(String LOG_TKTM) {
    this.LOG_TKTM = LOG_TKTM;
    return this;
  }
  private String LOG_ID;
  public String get_LOG_ID() {
    return LOG_ID;
  }
  public void set_LOG_ID(String LOG_ID) {
    this.LOG_ID = LOG_ID;
  }
  public QueryResult with_LOG_ID(String LOG_ID) {
    this.LOG_ID = LOG_ID;
    return this;
  }
  private String USR_NO;
  public String get_USR_NO() {
    return USR_NO;
  }
  public void set_USR_NO(String USR_NO) {
    this.USR_NO = USR_NO;
  }
  public QueryResult with_USR_NO(String USR_NO) {
    this.USR_NO = USR_NO;
    return this;
  }
  private String MENU_NM;
  public String get_MENU_NM() {
    return MENU_NM;
  }
  public void set_MENU_NM(String MENU_NM) {
    this.MENU_NM = MENU_NM;
  }
  public QueryResult with_MENU_NM(String MENU_NM) {
    this.MENU_NM = MENU_NM;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.LOG_TKTM == null ? that.LOG_TKTM == null : this.LOG_TKTM.equals(that.LOG_TKTM));
    equal = equal && (this.LOG_ID == null ? that.LOG_ID == null : this.LOG_ID.equals(that.LOG_ID));
    equal = equal && (this.USR_NO == null ? that.USR_NO == null : this.USR_NO.equals(that.USR_NO));
    equal = equal && (this.MENU_NM == null ? that.MENU_NM == null : this.MENU_NM.equals(that.MENU_NM));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.LOG_TKTM == null ? that.LOG_TKTM == null : this.LOG_TKTM.equals(that.LOG_TKTM));
    equal = equal && (this.LOG_ID == null ? that.LOG_ID == null : this.LOG_ID.equals(that.LOG_ID));
    equal = equal && (this.USR_NO == null ? that.USR_NO == null : this.USR_NO.equals(that.USR_NO));
    equal = equal && (this.MENU_NM == null ? that.MENU_NM == null : this.MENU_NM.equals(that.MENU_NM));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.LOG_TKTM = JdbcWritableBridge.readString(1, __dbResults);
    this.LOG_ID = JdbcWritableBridge.readString(2, __dbResults);
    this.USR_NO = JdbcWritableBridge.readString(3, __dbResults);
    this.MENU_NM = JdbcWritableBridge.readString(4, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.LOG_TKTM = JdbcWritableBridge.readString(1, __dbResults);
    this.LOG_ID = JdbcWritableBridge.readString(2, __dbResults);
    this.USR_NO = JdbcWritableBridge.readString(3, __dbResults);
    this.MENU_NM = JdbcWritableBridge.readString(4, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(LOG_TKTM, 1 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(LOG_ID, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(USR_NO, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(MENU_NM, 4 + __off, 12, __dbStmt);
    return 4;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(LOG_TKTM, 1 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(LOG_ID, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(USR_NO, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(MENU_NM, 4 + __off, 12, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.LOG_TKTM = null;
    } else {
    this.LOG_TKTM = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.LOG_ID = null;
    } else {
    this.LOG_ID = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.USR_NO = null;
    } else {
    this.USR_NO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.MENU_NM = null;
    } else {
    this.MENU_NM = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.LOG_TKTM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, LOG_TKTM);
    }
    if (null == this.LOG_ID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, LOG_ID);
    }
    if (null == this.USR_NO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, USR_NO);
    }
    if (null == this.MENU_NM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, MENU_NM);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.LOG_TKTM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, LOG_TKTM);
    }
    if (null == this.LOG_ID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, LOG_ID);
    }
    if (null == this.USR_NO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, USR_NO);
    }
    if (null == this.MENU_NM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, MENU_NM);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(LOG_TKTM==null?"null":LOG_TKTM, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(LOG_ID==null?"null":LOG_ID, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(USR_NO==null?"null":USR_NO, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(MENU_NM==null?"null":MENU_NM, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(LOG_TKTM==null?"null":LOG_TKTM, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(LOG_ID==null?"null":LOG_ID, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(USR_NO==null?"null":USR_NO, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(MENU_NM==null?"null":MENU_NM, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 44, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.LOG_TKTM = null; } else {
      this.LOG_TKTM = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.LOG_ID = null; } else {
      this.LOG_ID = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.USR_NO = null; } else {
      this.USR_NO = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.MENU_NM = null; } else {
      this.MENU_NM = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.LOG_TKTM = null; } else {
      this.LOG_TKTM = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.LOG_ID = null; } else {
      this.LOG_ID = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.USR_NO = null; } else {
      this.USR_NO = __cur_str;
    }

    if (__it.hasNext()) {
        __cur_str = __it.next();
    } else {
        __cur_str = "null";
    }
    if (__cur_str.equals("null")) { this.MENU_NM = null; } else {
      this.MENU_NM = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    return o;
  }

  public void clone0(QueryResult o) throws CloneNotSupportedException {
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new HashMap<String, Object>();
    __sqoop$field_map.put("LOG_TKTM", this.LOG_TKTM);
    __sqoop$field_map.put("LOG_ID", this.LOG_ID);
    __sqoop$field_map.put("USR_NO", this.USR_NO);
    __sqoop$field_map.put("MENU_NM", this.MENU_NM);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("LOG_TKTM", this.LOG_TKTM);
    __sqoop$field_map.put("LOG_ID", this.LOG_ID);
    __sqoop$field_map.put("USR_NO", this.USR_NO);
    __sqoop$field_map.put("MENU_NM", this.MENU_NM);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if (!setters.containsKey(__fieldName)) {
      throw new RuntimeException("No such field:"+__fieldName);
    }
    setters.get(__fieldName).setField(__fieldVal);
  }

}
