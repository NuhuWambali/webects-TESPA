//package com.webcorp.ects.ects;
//
//
//
//import static android.graphics.Color.BLACK;
//import static android.graphics.Color.WHITE;
//
//import android.graphics.Bitmap;
//import android.graphics.BitmapFactory;
//import android.os.Build;
//import android.os.Handler;
//
//import androidx.annotation.NonNull;
//import androidx.print.PrintHelper;
//
//import com.cloudpos.DeviceException;
//import com.cloudpos.POSTerminal;
//import com.cloudpos.printer.Format;
//import com.cloudpos.printer.PrinterDevice;
//import com.google.zxing.BarcodeFormat;
//import com.google.zxing.MultiFormatWriter;
//import com.google.zxing.common.BitMatrix;
//
//
//import org.json.JSONArray;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.math.BigDecimal;
//import java.math.RoundingMode;
//import java.text.NumberFormat;
//import java.util.Locale;
//
//import io.flutter.Log;
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugin.common.MethodChannel;
//
//
//public class MainActivity extends FlutterActivity {
//    private PrinterDevice printerDevice;
//    private Format format;
//    private static Handler handle = new Handler();
//    private static final String CHANNEL = "com.webcorp.ects.ects/Receipt";
//    private static final String CHANNEL2 = "com.webcorp.ects.ects/ReceiptCoppy";
//
//    JSONObject sr_main_object;
//    String receipt_v_code, qr_code;
//    JSONArray sr_array;
//    String sr_receipt_date, sr_receipt_total;
//
//    String sr_store_id, sr_companyVRN, sr_end_date, sr_start_date, sr_company_id,
//            sr_companyAddress, sr_companySerialNo, sr_companyTIN,
//            sr_companyName, sr_user_type, sr_companyUIN,
//            sr_companyMobile, sr_companyTaxOffice, sr_user_id, sr_user_name, sr_store_name;
//    int sr_total = 0;
//
//    String cmpn = "WEB CORPORATION LIMITED";
//    String addres ="Livingstone/Msimbazi Street";
//    String addres1 ="Falah (KFC) Building, 4th Floor";
//    String addres2 ="P.O.BOX 70307";
//    String addres3 ="Dar es salaam, Tanzania.";
//    String addres4 ="info@webcorporation.co.tz";
//    String addres5 ="webcorporation.co.tz";
//    String address6 ="Device Rental Details";
//
//    String contact= "0758451277/0713999331";
//    String contact2= "0686999711/0655011143";
//
//    String driver_name,trailorno,startdate,enddate,slaves,customerid, customername,amount,currency,vehicleno,offline_receiptno,receiptno,passport,agent,chasis,containerno,saledate,serialno,saleid,tzl,bordername,portname,prev_offline_receipt_number,offline_receipt_number,driver_number,tagger;
//
//
//
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//
//
//
//
//        //print sales report data - both bluetooth and POS
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
//                (call, result) -> {
//                    if (call.method.equals("receiptPrint")) {
//                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
//                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
//                        org.json.JSONObject salesReportData = new org.json.JSONObject(argDataSix);
//                        Log.d("Datafor", String.valueOf(argDataSix));
//                        getSalesReportData(salesReportData);
//                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
//                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportData.toString());
////                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
//                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
//                            printPOSSalesReport();
//                        }
//                    } else {
//                        result.notImplemented();
//                    }
//                }
//        );
//
//
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2).setMethodCallHandler(
//                (call, result) -> {
//                    if (call.method.equals("receiptPrint")) {
//                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
//                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
//                        org.json.JSONObject salesReportData = new org.json.JSONObject(argDataSix);
//                        Log.d("Datafor", String.valueOf(argDataSix));
//                        getSalesReportData(salesReportData);
//                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
//                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportData.toString());
////                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
//                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
//                            printPOSSalesReportCop();
//                        }
//                    } else {
//                        result.notImplemented();
//                    }
//                }
//        );
//    }
//
//    private Handler handler = new Handler();
//
//    private Runnable myRunnable = new Runnable() {
//        public void run() {
////            txt.setText(str);
//        }
//    };
//
//    public void getSalesReportData(JSONObject object) {
//        JSONObject main_obj;
//        String data = object.toString();
//        try {
//            main_obj = new JSONObject(data);
//            //Company Details
//            driver_name = main_obj.getString("driver_name");
//            containerno = main_obj.getString("container_number");
//            serialno = main_obj.getString("serial_no");
//
//            customername = main_obj.getString("company_name");
//            String amountt  = main_obj.getString("amount");
//            currency = main_obj.getString("currency");
//            vehicleno = main_obj.getString("vehicle_number");
//            receiptno = main_obj.getString("receipt_number");
//            agent = main_obj.getString("agent");
//
//           bordername = main_obj.getString("borderName");
//            portname = main_obj.getString("gateName");
//            tzl = main_obj.getString("tzl");
//            offline_receipt_number = main_obj.getString("offline_receipt_number");
//            offline_receiptno= main_obj.getString("offline_receipt_number");
//            prev_offline_receipt_number = main_obj.getString("prev_offline_receipt_number");
//            chasis = main_obj.getString("chasis_number");
//            passport = main_obj.getString("passport");
//            saledate = main_obj.getString("sale_date");
//            enddate =main_obj.getString("end_date");
//            driver_number = main_obj.getString("driver_number");
//            tagger= main_obj.getString("tagger");
//
//
//
//
//
//            System.out.print ( "object is for print ");
//
//            if (receiptno != null &&  !receiptno.isEmpty() && !receiptno.trim().equals("null")){
//                System.out.print ( "AMNAZO");
//                Log.d("AMNAZO", receiptno);
//                qr_code= receiptno;
//                //qr_code = offline_receipt_number;
////                Log.d("Print opened mike nullu",qr_code.toString());
//
//            }else{
//                System.out.print ( "AMNA data");
//                Log.d("AMNADATA", receiptno);
////                Log.d("Print else amana ipo",qr_code.toString());
////                qr_code= receiptno;
//                qr_code = offline_receipt_number;
//                Log.d("AMNA2", qr_code);
//            }
//
//
//
//
//
//
//            if (amountt == null){
//
//            } else if (amountt.equals("")){
//
//            }else{
//                amount = NumberFormat.getNumberInstance(Locale.US).format(Double.parseDouble(amountt));
//            }
//
//
//
//            String salesdata = main_obj.getString("slaves");
//            sr_array = new JSONArray(salesdata);
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }
//    }
//
//
//    private void printPOSSalesReport(){
////        Toast.makeText(context, "Printing...", Toast.LENGTH_SHORT).show();
////        handler.post(myRunnable);
//        openPrinter();
//        // printerDevice.open();
//        handler.post(myRunnable);
//        format = new Format();
//        try {
//            if (printerDevice.queryStatus() == printerDevice.STATUS_OUT_OF_PAPER) {
////                    str += context.getString(R.string.queryStatus) + "\n";
//                handler.post(myRunnable);
//            } else if (printerDevice.queryStatus() == printerDevice.STATUS_PAPER_EXIST) {
////                    str += context.getString(R.string.statusNor) + "\n";
//                handler.post(myRunnable);
//                Thread thread = new Thread(new Runnable() {
//
//                    @Override
//                    public void run() {
//                        // TODO Auto-generated method stub
//                        try {
//                            int printer_size = 32;
//                            int printer_size_uin = 50;
//
//                            //report from date
////                            String from_date = startdate;
////                            int from_date_count = from_date.length();
////                            String from_date_label = "FROM";
////                            int from_date_label_count = from_date_label.length();
////                            int middle_fromdate_space = printer_size - (from_date_label_count+from_date_count);
////                            String fromDateRow = from_date_label + getTotalWhiteSpace(middle_fromdate_space) + from_date +"\n";
////                            //========================================================
////                            //report to date
////                            String to_date = enddate;
////                            int to_date_count = to_date.length();
////                            String to_date_label = "TO";
////                            int to_date_label_count = to_date_label.length();
////                            int middle_todate_space = printer_size - (to_date_label_count+to_date_count);
////                            String toDateRow = to_date_label + getTotalWhiteSpace(middle_todate_space) + to_date +"\n";
////                            //========================================================
//
////                            //storeName
////                            String storeNm = sr_store_name;
////                            int storeNm_count = storeNm.length();
////                            String storeNm_label = "STORE";
////                            int storeNm_label_count = storeNm_label.length();
////                            int middle_storeNm_space = printer_size - (storeNm_label_count+storeNm_count);
////                            if(middle_storeNm_space<0){
////                                middle_storeNm_space = 1;
////                            }
////                            String storeNmRow = storeNm_label + getTotalWhiteSpace(middle_storeNm_space)+ storeNm+"\n";
//                            //========================================================
//                            //salePerson
////                            String salePer = "tagger";
////                            int salePer_count = salePer.length();
////                            String salePer_label = "SALE PERSON";
////                            int salePer_label_count = salePer_label.length();
////                            int middle_salePer_space = printer_size - (salePer_label_count+salePer_count);
////                            String salePerRow = salePer_label + getTotalWhiteSpace(middle_salePer_space)+ salePer+"\n";
////                            //========================================================
//
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, ".*** START OF RECEIPT ***");
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            printerDevice.printBitmap(format, LogoPOSPrint());
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.clear();
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format,""+cmpn+ "\n");
//                            printerDevice.printText(format, ""+addres+"\n");
//                            printerDevice.printText(format, ""+addres1+"\n");
//                            printerDevice.printText(format, ""+addres2+"\n");
//                            printerDevice.printText(format, ""+addres3+"\n");
//                            printerDevice.printText(format, ""+addres4+"\n");
//                            printerDevice.printText(format, ""+addres5+"\n" +
//                                    "--------------------------------");
//                            printerDevice.printText(format, "Device Rental Details\n" +
//                                    "--------------------------------");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "DATE"+saledate+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "Lease Number:"+"\n");
//                            printerDevice.printText(format, ""+qr_code+"\n");
//
////                            if (receiptno==null){
////                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
////                            }else if (receiptno.equals("")){
////                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
////                            }else{
////                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
////                            }
//
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Company Name: "+customername+"\n");
//                            printerDevice.printText(format, "Destination: "+bordername+"\n");
//
////                            printerDevice.printText(format, fromDateRow+"\n");
////                            printerDevice.printText(format, toDateRow+"\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Unit Number:"+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            format.setParameter("bold", "true");
//
//                            printerDevice.printText(format, ""+serialno+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "Vehicle Reg: "+vehicleno+"\n");
//                            printerDevice.printText(format, "Chassis: "+chasis+"\n");
//                            printerDevice.printText(format, "Driver name: "+driver_name+"\n");
//                            printerDevice.printText(format, "Driver phone: "+driver_number+"\n");
//
//
//
//
//
//                            printerDevice.printText(format, "Amount: "+amount+ currency+"\n");
//                            printerDevice.printText(format, "Port point: "+portname+"\n");
//                            printerDevice.printText(format, "TZDL number: "+tzl+"\n");
//                            printerDevice.printText(format, "Passport: "+passport+"\n");
//                            printerDevice.printText(format, "Tagger: "+tagger+"\n");
//                            printerDevice.printText(format, "Start date: "+saledate+"\n");
//                            printerDevice.printText(format, "End date: "+enddate+"\n");
//
//
////                            printerDevice.printText(format, storeNmRow+"\n");
////                            printerDevice.printText(format, salePerRow+"\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Contact us:"+contact+"\n");
//                            printerDevice.printText(format, ""+contact2+"\n");
//
//                            format.clear();
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
////                            printerDevice.printlnText(format, "\n");
//                            printerDevice.printBitmap(createBitmap("" + qr_code+"\n"));
////                            printerDevice.printlnText(format, "\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "*** END OF RECEIPT ***");
//                            printerDevice.printlnText(format, "\n");
////                            printerDevice.printlnText(format, "\n");
////                            printerDevice.printlnText(format, "\n");
//                            closePrinter();
//                        } catch (Exception e) {
//                            // TODO Auto-generated catch block
//                            e.printStackTrace();
//
//                        }
//                    }
//                });
//                thread.start();
//            }
//        } catch (DeviceException de) {
////                str += context.getString(R.string.checkStatus) + "\n";
//            handler.post(myRunnable);
//            de.printStackTrace();
//        }
//    }
//
//
//    private void printPOSSalesReportCop(){
////        Toast.makeText(context, "Printing...", Toast.LENGTH_SHORT).show();
////        handler.post(myRunnable);
//        openPrinter();
//        // printerDevice.open();
//        handler.post(myRunnable);
//        format = new Format();
//        try {
//            if (printerDevice.queryStatus() == printerDevice.STATUS_OUT_OF_PAPER) {
////                    str += context.getString(R.string.queryStatus) + "\n";
//                handler.post(myRunnable);
//            } else if (printerDevice.queryStatus() == printerDevice.STATUS_PAPER_EXIST) {
////                    str += context.getString(R.string.statusNor) + "\n";
//                handler.post(myRunnable);
//                Thread thread = new Thread(new Runnable() {
//
//                    @Override
//                    public void run() {
//                        // TODO Auto-generated method stub
//                        try {
//                            int printer_size = 32;
//                            int printer_size_uin = 50;
//
//                            //report from date
////                            String from_date = startdate;
////                            int from_date_count = from_date.length();
////                            String from_date_label = "FROM";
////                            int from_date_label_count = from_date_label.length();
////                            int middle_fromdate_space = printer_size - (from_date_label_count+from_date_count);
////                            String fromDateRow = from_date_label + getTotalWhiteSpace(middle_fromdate_space) + from_date +"\n";
////                            //========================================================
////                            //report to date
////                            String to_date = enddate;
////                            int to_date_count = to_date.length();
////                            String to_date_label = "TO";
////                            int to_date_label_count = to_date_label.length();
////                            int middle_todate_space = printer_size - (to_date_label_count+to_date_count);
////                            String toDateRow = to_date_label + getTotalWhiteSpace(middle_todate_space) + to_date +"\n";
////                            //========================================================
//
////                            //storeName
////                            String storeNm = sr_store_name;
////                            int storeNm_count = storeNm.length();
////                            String storeNm_label = "STORE";
////                            int storeNm_label_count = storeNm_label.length();
////                            int middle_storeNm_space = printer_size - (storeNm_label_count+storeNm_count);
////                            if(middle_storeNm_space<0){
////                                middle_storeNm_space = 1;
////                            }
////                            String storeNmRow = storeNm_label + getTotalWhiteSpace(middle_storeNm_space)+ storeNm+"\n";
//                            //========================================================
//                            //salePerson
////                            String salePer = "tagger";
////                            int salePer_count = salePer.length();
////                            String salePer_label = "SALE PERSON";
////                            int salePer_label_count = salePer_label.length();
////                            int middle_salePer_space = printer_size - (salePer_label_count+salePer_count);
////                            String salePerRow = salePer_label + getTotalWhiteSpace(middle_salePer_space)+ salePer+"\n";
////                            //========================================================
//
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, ".*** START OF RECEIPT ***");
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.setParameter("bold", "true");
//                            printerDevice.printText(format, ".*** COPY OF RECEIPT ***");
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.clear();
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
//                            printerDevice.printBitmap(format, LogoPOSPrint());
//                            printerDevice.printText("\n");
//                            printerDevice.printText("\n");
//                            format.clear();
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format,""+cmpn+ "\n");
//                            printerDevice.printText(format, ""+addres+"\n");
//                            printerDevice.printText(format, ""+addres1+"\n");
//                            printerDevice.printText(format, ""+addres2+"\n");
//                            printerDevice.printText(format, ""+addres3+"\n");
//                            printerDevice.printText(format, ""+addres4+"\n");
//                            printerDevice.printText(format, ""+addres5+"\n" +
//                                    "--------------------------------");
//                            printerDevice.printText(format, "Device Rental Details\n" +
//                                    "--------------------------------");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "DATE"+saledate+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "Lease Number:"+"\n");
//                            printerDevice.printText(format, ""+qr_code+"\n");
//
////                            if (receiptno==null){
////                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
////                            }else if (receiptno.equals("")){
////                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
////                            }else{
////                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
////                            }
//
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Company Name: "+customername+"\n");
//                            printerDevice.printText(format, "Destination: "+bordername+"\n");
//
////                            printerDevice.printText(format, fromDateRow+"\n");
////                            printerDevice.printText(format, toDateRow+"\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Unit Number:"+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            format.setParameter("bold", "true");
//
//                            printerDevice.printText(format, ""+serialno+"\n");
//                            format.clear();
//                            format.setParameter("align", "left");
//                            format.setParameter("size", "medium");
//                            printerDevice.printText(format, "Vehicle Reg: "+vehicleno+"\n");
//                            printerDevice.printText(format, "Chassis: "+chasis+"\n");
//                            printerDevice.printText(format, "Driver name: "+driver_name+"\n");
//                            printerDevice.printText(format, "Driver phone: "+driver_number+"\n");
//
//
//
//
//
//                            printerDevice.printText(format, "Amount: "+amount+ currency+"\n");
//                            printerDevice.printText(format, "Port point: "+portname+"\n");
//                            printerDevice.printText(format, "TZDL number: "+tzl+"\n");
//                            printerDevice.printText(format, "Passport: "+passport+"\n");
//                            printerDevice.printText(format, "Tagger: "+tagger+"\n");
//                            printerDevice.printText(format, "Start date: "+saledate+"\n");
//                            printerDevice.printText(format, "End date: "+enddate+"\n");
//
//
////                            printerDevice.printText(format, storeNmRow+"\n");
////                            printerDevice.printText(format, salePerRow+"\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Contact us:"+contact+"\n");
//                            printerDevice.printText(format, ""+contact2+"\n");
//
//                            format.clear();
//                            format.setParameter("align", "center");
//                            format.setParameter("size", "medium");
////                            printerDevice.printlnText(format, "\n");
//                            printerDevice.printBitmap(createBitmap("" + qr_code+"\n"));
////                            printerDevice.printlnText(format, "\n");
//                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "*** END OF RECEIPT ***");
//                            printerDevice.printlnText(format, "\n");
////                            printerDevice.printlnText(format, "\n");
////                            printerDevice.printlnText(format, "\n");
//                            closePrinter();
//                        } catch (Exception e) {
//                            // TODO Auto-generated catch block
//                            e.printStackTrace();
//
//                        }
//                    }
//                });
//                thread.start();
//            }
//        } catch (DeviceException de) {
////                str += context.getString(R.string.checkStatus) + "\n";
//            handler.post(myRunnable);
//            de.printStackTrace();
//        }
//    }
//
//
//
//    private android.graphics.Bitmap createBitmap(String text) {
//        BitMatrix result = null;
//        try {
//            result = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, 250, 210, null);
//        } catch (com.google.zxing.WriterException e) {
//            e.printStackTrace();
//            return null;
//        }
//        int width = result.getWidth();
//        int height = result.getHeight();
//        int[] pixels = new int[width * height];
//
//        for (int x = 0; x < height; x++) {
//            int offset = x * width;
//            for (int k = 0; k < width; k++) {
//                pixels[offset + k] = result.get(k, x) ? BLACK : WHITE;
//            }
//        }
//        android.graphics.Bitmap myBitmap = android.graphics.Bitmap.createBitmap(width, height, android.graphics.Bitmap.Config.ARGB_8888);
//        myBitmap.setPixels(pixels, 0, width, 0, 0, width, height);
//        return myBitmap;
//    }
//
//
//    public static String getTotalWhiteSpace(int size) {
//        StringBuilder builder = new StringBuilder(size);
//        for (int i = 0; i < size; i++) {
//            builder.append(' ');
//        }
//        return builder.toString();
//    }
//
//    private void openPrinter() {
//        try {
//            //Toast.makeText(context, "Open Successfull", Toast.LENGTH_SHORT).show();
//            printerDevice.open();
//            Log.d("Print opened mike","Imefunguka");
////            str += context.getString(R.string.closeSuc) + "\n";
//            handler.post(myRunnable);
//        } catch (DeviceException e) {
//            //Toast.makeText(context, "fail to open printer"+e.toString(), Toast.LENGTH_SHORT).show();
//            Log.d("Print opened mike",e.toString());
//
//            // TODO Auto-generated catch block
//            e.printStackTrace();
////            str += context.getString(R.string.closeFailed) + "\n";
//            handler.post(myRunnable);
//        }
//    }
//
//    private void closePrinter() {
//        try {
//            printerDevice.close();
////            str += context.getString(R.string.closeSuc) + "\n";
//            handler.post(myRunnable);
//        } catch (DeviceException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
////            str += context.getString(R.string.closeFailed) + "\n";
//            handler.post(myRunnable);
//        }
//    }
//
//    private Bitmap LogoPOSPrint() {
//        PrintHelper photoPrinter = new PrintHelper(MainActivity.this);
//        photoPrinter.setScaleMode(PrintHelper.SCALE_MODE_FIT);
//        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.logoweb);
//        Bitmap resized = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * 0.3), (int) (bitmap.getHeight() * 0.3), true);
//        return resized;
//    }
//
//
//
//}
