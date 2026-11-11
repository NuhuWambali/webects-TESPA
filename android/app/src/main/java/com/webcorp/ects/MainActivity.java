package com.webcorp.ects;


import static android.graphics.Color.BLACK;
import static android.graphics.Color.WHITE;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.RemoteException;

import androidx.annotation.NonNull;
import androidx.print.PrintHelper;

import com.cloudpos.DeviceException;
import com.cloudpos.POSTerminal;
import com.cloudpos.printer.Format;
import com.cloudpos.printer.PrinterDevice;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.transsnet.palmpay.lib.PalmPayUsdkKernel;
import com.transsnet.sdk.palmpayusdk.BasicProvider;
import com.transsnet.sdk.palmpayusdk.CardProvider;
import com.transsnet.sdk.palmpayusdk.EMVProvider;
import com.transsnet.sdk.palmpayusdk.InitPOSListener;
import com.transsnet.sdk.palmpayusdk.PinPadProvider;
import com.transsnet.sdk.palmpayusdk.PrinterListener;
import com.transsnet.sdk.palmpayusdk.PrinterProvider;
import com.transsnet.sdk.palmpayusdk.SecurityProivder;
import com.transsnet.sdk.palmpayusdk.constant.Constant;
import com.webcorp.ects.ects.printer.USBPrint;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.Locale;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private PrinterDevice printerDevice;
    private Format format;
    private static Handler handle = new Handler();
    private static final String CHANNEL = "com.webcorp.ects/Receipt";
    private static final String CHANNEL2 = "com.webcorp.ects/ReceiptCoppy";
    private static final String CHANNEL3 = "com.webcorp.ects/DuplicateReceipt";

    public BasicProvider basicProvider;
    private PalmPayUsdkKernel mPalmPayUsdkKernel;


    private PrinterProvider mPrinterProvider;
    public CardProvider mCardProvider;
    public PinPadProvider mPinPadProvider;
    public EMVProvider mEmvProvider;
    public SecurityProivder mSecurityProvider;

    private String alineStr = Constant.PrintAlignKey.CENTER_ALIGN;
    private String alineLeft = Constant.PrintAlignKey.LEFT_ALIGN;
    private String alineRight = Constant.PrintAlignKey.RIGHT_ALIGN;
    private String fontStr = Constant.PrintFontKey.NORMAL_TEXT;

    private String fontbold = Constant.PrintFontKey.LARGE_TEXT;

    private String fontlg = Constant.PrintFontKey.XXL_TEXT;
    private int boldType = 0;

    private int boldTtype = 1;

    private int italicType = 0;

    USBPrint usbPrint;


    JSONObject sr_main_object;
    String receipt_v_code, qr_code;
    JSONArray sr_array;
    String sr_receipt_date, sr_receipt_total;

    String sr_store_id, sr_companyVRN, sr_end_date, sr_start_date, sr_company_id,
            sr_companyAddress, sr_companySerialNo, sr_companyTIN,
            sr_companyName, sr_user_type, sr_companyUIN,
            sr_companyMobile, sr_companyTaxOffice, sr_user_id, sr_user_name, sr_store_name;
    int sr_total = 0;

    int branchId = 1;

    String cmpn = "WEB CORPORATION LIMITED";
    String addres ="Livingstone/Msimbazi Street";
    String addres1 ="Falah (KFC) Building, 4th Floor";
    String addres2 ="P.O.BOX 70307";
    String addres3 ="Dar es salaam, Tanzania.";
    String addres4 ="info@webcorporation.co.tz";
    String addres5 ="webcorporation.co.tz";
    String address6 ="Device Rental Details";

    String contact= "0677080458/0759888333";
    String contact2= "0677080457/0677074430";

    String contacta= "0677080458/0759888333";
    String contacta2= "0654955111/0712555660";


    String driver_name,trailorno,startdate,enddate,customerid, customername,amount,currency,vehicleno,offline_receiptno,receiptno,passport,agent,chasis,containerno,saledate,serialno,saleid,tzl,bordername,portname,prev_offline_receipt_number,offline_receipt_number,driver_number,tagger;

    String receiptname,user,startdaten,enddaten,total,border,saletype;
    JSONArray devices_array,slaves;


    public static final String TAG = "MyApplication";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);



        android.util.Log.d(TAG, "configureFlutterEngine: NAANZAPALM");
        if(Build.MODEL.equals("P2_SE")) {
            bindService();
            android.util.Log.d(TAG, "configureFlutterEngine: NAANZAPALMto");
//            printPlampay();

        }




        //print sales report data - both bluetooth and POS
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("receiptPrint")) {
                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
                        JSONObject salesReportData = new JSONObject(argDataSix);
                        Log.d("Datafor", String.valueOf(argDataSix));
                        getSalesReportData(salesReportData);
                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportData.toString());
//                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
                            printPOSSalesReport();
                        } else if (Build.MODEL.equals("P2_SE")) {
                            printPlampay();


                    } else if (Build.MODEL.equals("P8")) {
//                        Toast.makeText(this, Build.MODEL.toString(), Toast.LENGTH_LONG).show();
//                        HashMap<String, Object> argData = (HashMap<String, Object>) call.arguments;
//                        JSONObject obj = new JSONObject(argData);
//                                getPOSData(obj);
                        telpoInit(salesReportData, result);
                    }
                        else{

                            return;
                        }
                    }else if(call.method.equals("reportPrint")){

                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
                        JSONObject salesReportDataD = new JSONObject(argDataSix);
                        Log.d("Dataforrpott", String.valueOf(argDataSix));
//                        getDeviceReportData(salesReportDataD);
                        getDeviceReportData(salesReportDataD);
                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportDataD.toString());
//                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
                            printPOSDeviceReport();
                        } else if (Build.MODEL.equals("P2_SE")) {
//                            printPlampay();
                            android.util.Log.d(TAG, "PALMA REPORTT: ");
                            printPOSDeviceReportPalm();

                        } else if (Build.MODEL.equals("P8")) {
//                        Toast.makeText(this, Build.MODEL.toString(), Toast.LENGTH_LONG).show();
//                        HashMap<String, Object> argData = (HashMap<String, Object>) call.arguments;
//                        JSONObject obj = new JSONObject(argData);
//                                getPOSData(obj);
                            telpoInitdevice(salesReportDataD, result);
                        }


                    }


                    else {
                        result.notImplemented();
                    }
                }
        );


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL2).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("receiptPrint")) {
                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
                        JSONObject salesReportData = new JSONObject(argDataSix);
                        Log.d("Datafor", String.valueOf(argDataSix));
                        getSalesReportData(salesReportData);
                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportData.toString());
//                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
                            printPOSSalesReportCop();
                        } else if (Build.MODEL.equals("P2_SE")) {
//                            printPlampay();
                            printPlampaycop();

                        }else if (Build.MODEL.equals("P8")) {
//                        Toast.makeText(this, Build.MODEL.toString(), Toast.LENGTH_LONG).show();
//                        HashMap<String, Object> argData = (HashMap<String, Object>) call.arguments;
//                        JSONObject obj = new JSONObject(argData);
//                                getPOSData(obj);
                            telpoInitcop(salesReportData, result);
                        }


                    } else {
                        result.notImplemented();
                    }
                }
        );

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL3).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("receiptPrint")) {
                        java.util.HashMap<String, Object> argDataSix = (java.util.HashMap<String, Object>) call.arguments;
                        Log.d("DatafroPrinte", String.valueOf(argDataSix));
                        JSONObject salesReportData = new JSONObject(argDataSix);
                        Log.d("Datafor", String.valueOf(argDataSix));
                        getSalesReportData(salesReportData);
                        if (Build.MODEL.equals("WIZARPOS Q2") || Build.MODEL.equals("WIZARPOS Q2(K2)") ||  Build.MODEL.equals("WIZARPOS Q2(Q2E6)") || Build.MODEL.equals("WIZARPOS K2") || Build.MODEL.equals("WebPOS W1")){
                            Log.i("POS: ", "POS Sales Data To Print = " + salesReportData.toString());
//                            Toast.makeText(MainActivity.this, Build.MODEL.toString(), Toast.LENGTH_SHORT).show();
                            printerDevice = (PrinterDevice) POSTerminal.getInstance(getApplicationContext()).getDevice("cloudpos.device.printer");
                            printPOSSalesReportCop();
                        } else if (Build.MODEL.equals("P2_SE")) {
//                            printPlampay();
                            printPlampaycop();

                        }else if (Build.MODEL.equals("P8")) {
//                        Toast.makeText(this, Build.MODEL.toString(), Toast.LENGTH_LONG).show();
//                        HashMap<String, Object> argData = (HashMap<String, Object>) call.arguments;
//                        JSONObject obj = new JSONObject(argData);
//                                getPOSData(obj);
                            telpoInitcop(salesReportData, result);
                        }


                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private Handler handler = new Handler();

    private Runnable myRunnable = new Runnable() {
        public void run() {
//            txt.setText(str);
        }
    };


    private void telpoInit(JSONObject printData, MethodChannel.Result result){
        usbPrint = new USBPrint(this, data -> runOnUiThread(() -> {
        }));
        TelpoPrint(printData, result);
        result.success(1);
    }

    private void TelpoPrint(JSONObject printData, MethodChannel.Result result) {
        usbPrint.printContent_58(printData, result);
    }


    private void telpoInitcop(JSONObject printData, MethodChannel.Result result){
        usbPrint = new USBPrint(this, data -> runOnUiThread(() -> {
        }));
        TelpoPrintcop(printData, result);
        result.success(1);
    }

    private void TelpoPrintcop(JSONObject printData, MethodChannel.Result result) {
        usbPrint.printContent_58cop(printData, result);
    }


    private void telpoInitdevice(JSONObject printData, MethodChannel.Result result){
        usbPrint = new USBPrint(this, data -> runOnUiThread(() -> {
        }));
        TelpoPrintdevice(printData, result);
        result.success(1);
    }

    private void TelpoPrintdevice(JSONObject printData, MethodChannel.Result result) {
        usbPrint.printContentdevice(printData, result);
    }


    public void getSalesReportData(JSONObject object) {
        JSONObject main_obj;
        String data = object.toString();
        try {
            main_obj = new JSONObject(data);
            //Company Details

            branchId = main_obj.getInt("branchId");


            driver_name = main_obj.getString("driver_name");
            containerno = main_obj.getString("container_number");
            serialno = main_obj.getString("serial_no");
            trailorno= main_obj.getString("trailerno");

            customername = main_obj.getString("company_name");
            String amountt  = main_obj.getString("amount");
            currency = main_obj.getString("currency");
            vehicleno = main_obj.getString("vehicle_number");
            receiptno = main_obj.getString("receipt_number");
            agent = main_obj.getString("agent");

           bordername = main_obj.getString("borderName");
            portname = main_obj.getString("gateName");
            tzl = main_obj.getString("tzl");
            offline_receipt_number = main_obj.getString("offline_receipt_number");
            offline_receiptno= main_obj.getString("offline_receipt_number");
            prev_offline_receipt_number = main_obj.getString("prev_offline_receipt_number");
            chasis = main_obj.getString("chasis_number");
            passport = main_obj.getString("passport");
            saledate = main_obj.getString("sale_date");
            enddate =main_obj.getString("end_date");
            driver_number = main_obj.getString("driver_number");
            tagger= main_obj.getString("tagger");
            saletype=  main_obj.getString("sale_type");





            System.out.print ( "object is for print ");

            if (receiptno != null &&  !receiptno.isEmpty() && !receiptno.trim().equals("null")){
                System.out.print ( "AMNAZO");
                Log.d("AMNAZO", receiptno);
                qr_code= receiptno;
                //qr_code = offline_receipt_number;
//                Log.d("Print opened mike nullu",qr_code.toString());

            }else{
                System.out.print ( "AMNA data");
                Log.d("AMNADATA", receiptno);
//                Log.d("Print else amana ipo",qr_code.toString());
//                qr_code= receiptno;
                qr_code = offline_receipt_number;
                Log.d("AMNA2", qr_code);
            }






            if (amountt == null){

            } else if (amountt.equals("")){

            }else{
                amount = NumberFormat.getNumberInstance(Locale.US).format(Double.parseDouble(amountt));
            }





            slaves = main_obj.getJSONArray("slaves");


//            sr_array = new JSONArray(salesdata);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void getDeviceReportData(JSONObject object) {
        JSONObject main_obj;
        String data = object.toString();
        try {
            main_obj = new JSONObject(data);
            //Company Details
            receiptname= "Border Return Report";
            user = main_obj.getString("user");
            total = main_obj.getString("total");
            startdate = main_obj.getString("date_from");
            enddate = main_obj.getString("date_to");
            border  = main_obj.getString("border");
            devices_array = main_obj.getJSONArray("devices");



        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    private void printPOSSalesReport(){
//        Toast.makeText(context, "Printing...", Toast.LENGTH_SHORT).show();
//        handler.post(myRunnable);
        openPrinter();
        // printerDevice.open();
        handler.post(myRunnable);
        format = new Format();
        try {
            if (printerDevice.queryStatus() == printerDevice.STATUS_OUT_OF_PAPER) {
//                    str += context.getString(R.string.queryStatus) + "\n";
                handler.post(myRunnable);
            } else if (printerDevice.queryStatus() == printerDevice.STATUS_PAPER_EXIST) {
//                    str += context.getString(R.string.statusNor) + "\n";
                handler.post(myRunnable);
                Thread thread = new Thread(new Runnable() {

                    @Override
                    public void run() {
                        // TODO Auto-generated method stub
                        try {
                            int printer_size = 32;
                            int printer_size_uin = 50;



                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, ".*** Web ECTS Order ***");
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            printerDevice.printBitmap(format, LogoPOSPrint());
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format,""+cmpn+ "\n");
                            printerDevice.printText(format, ""+addres+"\n");
                            printerDevice.printText(format, ""+addres1+"\n");
                            printerDevice.printText(format, ""+addres2+"\n");
                            printerDevice.printText(format, ""+addres3+"\n");
                            printerDevice.printText(format, ""+addres4+"\n");
                            printerDevice.printText(format, ""+addres5+"\n" +
                                    "--------------------------------");
                            printerDevice.printText(format, "Device Rental Details\n" +
                                    "--------------------------------");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "DATE: "+saledate+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "Lease Number:"+"\n");
                            printerDevice.printText(format, ""+qr_code+"\n");

//                            if (receiptno==null){
//                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
//                            }else if (receiptno.equals("")){
//                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
//                            }else{
//                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
//                            }

                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
                            printerDevice.printText(format, "Company Name: "+customername+"\n");
                            printerDevice.printText(format, "Destination: "+bordername+"\n");

//                            printerDevice.printText(format, fromDateRow+"\n");
//                            printerDevice.printText(format, toDateRow+"\n");
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Unit Number:"+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            format.setParameter("bold", "true");
                            printerDevice.printText(format, "Unit Number: "+serialno+"\n");

//                            printerDevice.printText(format, ""+serialno+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "Slave"+"\n");
                            for (int k = 0; k < slaves.length(); k++) {
                                JSONObject items_obj = slaves.getJSONObject(k);
                                String snn = items_obj.getString("serial_no");
                                printerDevice.printText(format, "SN: "+snn+"\n");

                            }


                            printerDevice.printText(format, "Vehicle Reg: "+vehicleno+"\n");
                            printerDevice.printText(format, "Chassis: "+chasis+"\n");
//                            printerDevice.printText(format, "Trailer number: "+trailorno+"\n");
//                            printerDevice.printText(format, "Container number: "+containerno+"\n");
//

                            printerDevice.printText(format, "Driver name: "+driver_name+"\n");
                            printerDevice.printText(format, "Driver phone: "+driver_number+"\n");




                            printerDevice.printText(format, "Sale type : CASH\n");
//                          if (saletype.equals("3")){
//
//                              printerDevice.printText(format, "Sale type : BILL"+"\n");
//                          }else{
//                              printerDevice.printText(format, "Sale type : "+ currency+"\n");
//                              printerDevice.printText(format, "Amount: "+amount+ currency+"\n");
//                          }






                            printerDevice.printText(format, "Port point: "+portname+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            format.setParameter("bold", "true");
                            printerDevice.printText(format, "TZDL number: "+tzl+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");

                            printerDevice.printText(format, "Passport: "+passport+"\n");
                            printerDevice.printText(format, "Tagger: "+tagger+"\n");
                            printerDevice.printText(format, "Start date : "+saledate+"\n");
                            printerDevice.printText(format, "End date: "+enddate+"\n");


//                            printerDevice.printText(format, storeNmRow+"\n");
//                            printerDevice.printText(format, salePerRow+"\n");


                            printerDevice.printText(format, "" + "--------------------------------"+"\n");

                            if (branchId==4){
                                printerDevice.printText(format, "Contact us:"+contacta+"\n");
                                printerDevice.printText(format, ""+contacta2+"\n");
                            }else {
                                printerDevice.printText(format, "Contact us:"+contact+"\n");
                                printerDevice.printText(format, ""+contact2+"\n");
                            }




                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
//                            printerDevice.printlnText(format, "\n");
                            printerDevice.printBitmap(format,createBitmap("" + qr_code+"\n"));
//                            printerDevice.printlnText(format, "\n");


                            if (branchId==4){
//                                printerDevice.printText(format, "Powered by:");
//                                printerDevice.printBitmap(format, LogoPOSPrintbottom());
                            }else {
//                                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                                printerDevice.printText(format, ""+contact2+"\n");
                            }




                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
                            printerDevice.printText(format, "*** END OF Web ECTS Order ***");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            closePrinter();
                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();

                        }
                    }
                });
                thread.start();
            }
        } catch (DeviceException de) {
//                str += context.getString(R.string.checkStatus) + "\n";
            handler.post(myRunnable);
            de.printStackTrace();
        }
    }


    private void printPOSSalesReportCop(){
//        Toast.makeText(context, "Printing...", Toast.LENGTH_SHORT).show();
//        handler.post(myRunnable);
        openPrinter();
        // printerDevice.open();
        handler.post(myRunnable);
        format = new Format();
        try {
            if (printerDevice.queryStatus() == printerDevice.STATUS_OUT_OF_PAPER) {
//                    str += context.getString(R.string.queryStatus) + "\n";
                handler.post(myRunnable);
            } else if (printerDevice.queryStatus() == printerDevice.STATUS_PAPER_EXIST) {
//                    str += context.getString(R.string.statusNor) + "\n";
                handler.post(myRunnable);
                Thread thread = new Thread(new Runnable() {

                    @Override
                    public void run() {
                        // TODO Auto-generated method stub
                        try {
                            int printer_size = 32;
                            int printer_size_uin = 50;

                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, ".*** Web ECTS Order ***");
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.setParameter("bold", "true");
                            printerDevice.printText(format, " COPY ");
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printBitmap(format, LogoPOSPrint());
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format,""+cmpn+ "\n");
                            printerDevice.printText(format, ""+addres+"\n");
                            printerDevice.printText(format, ""+addres1+"\n");
                            printerDevice.printText(format, ""+addres2+"\n");
                            printerDevice.printText(format, ""+addres3+"\n");
                            printerDevice.printText(format, ""+addres4+"\n");
                            printerDevice.printText(format, ""+addres5+"\n" +
                                    "--------------------------------");
                            printerDevice.printText(format, "Device Rental Details\n" +
                                    "--------------------------------");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "DATE: "+saledate+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "Lease Number:"+"\n");
                            printerDevice.printText(format, ""+qr_code+"\n");


//                            if (receiptno==null){
//                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
//                            }else if (receiptno.equals("")){
//                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
//                            }else{
//                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
//                            }

                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
                            printerDevice.printText(format, "Company Name: "+customername+"\n");
                            printerDevice.printText(format, "Destination: "+bordername+"\n");

//                            printerDevice.printText(format, fromDateRow+"\n");
//                            printerDevice.printText(format, toDateRow+"\n");
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Unit Number:"+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            format.setParameter("bold", "true");

//                            printerDevice.printText(format, ""+serialno+"\n");
                            printerDevice.printText(format, "Unit Number: "+serialno+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");

                            printerDevice.printText(format, "Slave"+"\n");
                            for (int k = 0; k < slaves.length(); k++) {
                                JSONObject items_obj = slaves.getJSONObject(k);
                                String snn = items_obj.getString("serial_no");
                                printerDevice.printText(format, "SN: "+snn+"\n");

                            }
                            printerDevice.printText(format, "Vehicle Reg: "+vehicleno+"\n");
                            printerDevice.printText(format, "Chassis: "+chasis+"\n");
                            printerDevice.printText(format, "Driver name: "+driver_name+"\n");
                            printerDevice.printText(format, "Driver phone: "+driver_number+"\n");
                            printerDevice.printText(format, "Trailer number: "+trailorno+"\n");
                            printerDevice.printText(format, "Container number: "+containerno+"\n");








//                            printerDevice.printText(format, "Amount: "+amount+ currency+"\n");
//                            if (saletype.equals("3")){
//
//                                printerDevice.printText(format, "Sale type : BILL"+"\n");
//                            }else{
//                                printerDevice.printText(format, "Sale type : "+ currency+"\n");
//                                printerDevice.printText(format, "Amount: "+amount+ currency+"\n");
//                            }
                            printerDevice.printText(format, "Sale type : CASH\n");
                            printerDevice.printText(format, "Port point: "+portname+"\n");
//                            printerDevice.printText(format, "TZDL number: "+tzl+"\n");


                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            format.setParameter("bold", "true");

                            printerDevice.printText(format, "TZDL number: "+tzl+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");


                            printerDevice.printText(format, "Passport: "+passport+"\n");
                            printerDevice.printText(format, "Tagger: "+tagger+"\n");
                            printerDevice.printText(format, "Start date: "+saledate+"\n");
                            printerDevice.printText(format, "End date: "+enddate+"\n");


//                            printerDevice.printText(format, storeNmRow+"\n");
//                            printerDevice.printText(format, salePerRow+"\n");
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
//                            printerDevice.printText(format, "Contact us:"+contact+"\n");
//                            printerDevice.printText(format, ""+contact2+"\n");


                            if (branchId==4){
                                printerDevice.printText(format, "Contact us:"+contacta+"\n");
                                printerDevice.printText(format, ""+contacta2+"\n");
                            }else {
                                printerDevice.printText(format, "Contact us:"+contact+"\n");
                                printerDevice.printText(format, ""+contact2+"\n");
                            }



                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
//                            printerDevice.printlnText(format, "\n");
                            printerDevice.printBitmap(format,createBitmap("" + qr_code+"\n"));
//                            printerDevice.printlnText(format, "\n");



                            if (branchId==4){
//                                printerDevice.printText(format, "Powered by:");
//                                printerDevice.printBitmap(format, LogoPOSPrintbottom());
                            }else {
//                                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                                printerDevice.printText(format, ""+contact2+"\n");
                            }

                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
                            printerDevice.printText(format, "*** Web ECTS Order ***");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            closePrinter();
                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();

                        }
                    }
                });
                thread.start();
            }
        } catch (DeviceException de) {
//                str += context.getString(R.string.checkStatus) + "\n";
            handler.post(myRunnable);
            de.printStackTrace();
        }
    }


    private void printPOSDeviceReport(){
//        Toast.makeText(context, "Printing...", Toast.LENGTH_SHORT).show();
//        handler.post(myRunnable);
        openPrinter();
        // printerDevice.open();
        handler.post(myRunnable);
        format = new Format();
        try {
            if (printerDevice.queryStatus() == printerDevice.STATUS_OUT_OF_PAPER) {
//                    str += context.getString(R.string.queryStatus) + "\n";
                handler.post(myRunnable);
            } else if (printerDevice.queryStatus() == printerDevice.STATUS_PAPER_EXIST) {
//                    str += context.getString(R.string.statusNor) + "\n";
                handler.post(myRunnable);
                Thread thread = new Thread(new Runnable() {

                    @Override
                    public void run() {
                        // TODO Auto-generated method stub
                        try {
                            int printer_size = 32;
                            int printer_size_uin = 50;

                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, ".*** START OF REPORT ***");
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");

                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printBitmap(format, LogoPOSPrint());
                            printerDevice.printText("\n");
                            printerDevice.printText("\n");
                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format,""+cmpn+ "\n");
                            printerDevice.printText(format, ""+addres+"\n");
                            printerDevice.printText(format, ""+addres1+"\n");
                            printerDevice.printText(format, ""+addres2+"\n");
                            printerDevice.printText(format, ""+addres3+"\n");
                            printerDevice.printText(format, ""+addres4+"\n");
                            printerDevice.printText(format, ""+addres5+"\n" +
                                    "--------------------------------");
                            printerDevice.printText(format, "Device Border Return Report\n" +
                                    "--------------------------------");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");


                            printerDevice.printText(format, "Border:  "+border+"\n");
                            printerDevice.printText(format, "StartDate:  "+startdate+"\n");
                            printerDevice.printText(format, "EndDate:  "+enddate+"\n");
                            printerDevice.printText(format, "User:   "+user+"\n");
                            printerDevice.printText(format, "Total Device:  "+total+"\n");
                            format.clear();
                            format.setParameter("align", "left");
                            format.setParameter("size", "medium");
                            printerDevice.printText(format, "" +
                                    "--------------------------------");

                            printerDevice.printText(format, "Device List\n" +
                                    "--------------------------------");
                            for (int k = 0; k < devices_array.length(); k++) {
                                    JSONObject items_obj = devices_array.getJSONObject(k);
                                    String snn = items_obj.getString("serial_no");
                                printerDevice.printText(format, "SN: "+snn+"\n");

                                }
                            printerDevice.printlnText(format, "\n");
//                            printerDevice.printlnText(format, "\n");


                            //
                            if (branchId==4){
                                printerDevice.printText(format, "Contact us:"+contacta+"\n");
                                printerDevice.printText(format, ""+contacta2+"\n");
                            }else {
                                printerDevice.printText(format, "Contact us:"+contact+"\n");
                                printerDevice.printText(format, ""+contact2+"\n");
                            }



                            format.clear();
                            format.setParameter("align", "center");
                            format.setParameter("size", "medium");

                            if (branchId==4){
//                                printerDevice.printText(format, "Powered by:");
//                                printerDevice.printBitmap(format, LogoPOSPrintbottom());
                            }else {
//                                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                                printerDevice.printText(format, ""+contact2+"\n");
                            }



//                            printerDevice.printText(format, "Powered by:");
//                            printerDevice.printBitmap(format, LogoPOSPrintbottom());
                            printerDevice.printText(format, "" + "--------------------------------"+"\n");
                            printerDevice.printText(format, "*** END OF RERPORT ***");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            printerDevice.printlnText(format, "\n");
                            closePrinter();
                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();

                        }
                    }
                });
                thread.start();
            }
        } catch (DeviceException de) {
//                str += context.getString(R.string.checkStatus) + "\n";
            handler.post(myRunnable);
            de.printStackTrace();
        }
    }



    private Bitmap createBitmap(String text) {
        BitMatrix result = null;
        try {
            result = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, 190, 190, null);
        } catch (com.google.zxing.WriterException e) {
            e.printStackTrace();
            return null;
        }
        int width = result.getWidth();
        int height = result.getHeight();
        int[] pixels = new int[width * height];

        for (int x = 0; x < height; x++) {
            int offset = x * width;
            for (int k = 0; k < width; k++) {
                pixels[offset + k] = result.get(k, x) ? BLACK : WHITE;
            }
        }
        Bitmap myBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        myBitmap.setPixels(pixels, 0, width, 0, 0, width, height);
        return myBitmap;
    }


    public static String getTotalWhiteSpace(int size) {
        StringBuilder builder = new StringBuilder(size);
        for (int i = 0; i < size; i++) {
            builder.append(' ');
        }
        return builder.toString();
    }

    private void openPrinter() {
        try {
            //Toast.makeText(context, "Open Successfull", Toast.LENGTH_SHORT).show();
            printerDevice.open();
            Log.d("Print opened mike","Imefunguka");
//            str += context.getString(R.string.closeSuc) + "\n";
            handler.post(myRunnable);
        } catch (DeviceException e) {
            //Toast.makeText(context, "fail to open printer"+e.toString(), Toast.LENGTH_SHORT).show();
            Log.d("Print opened mike",e.toString());

            // TODO Auto-generated catch block
            e.printStackTrace();
//            str += context.getString(R.string.closeFailed) + "\n";
            handler.post(myRunnable);
        }
    }

    private void closePrinter() {
        try {
            printerDevice.close();
//            str += context.getString(R.string.closeSuc) + "\n";
            handler.post(myRunnable);
        } catch (DeviceException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
//            str += context.getString(R.string.closeFailed) + "\n";
            handler.post(myRunnable);
        }
    }

    private Bitmap LogoPOSPrint() {
        PrintHelper photoPrinter = new PrintHelper(MainActivity.this);
        photoPrinter.setScaleMode(PrintHelper.SCALE_MODE_FIT);
        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.logov);
        Bitmap resized = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * 0.3), (int) (bitmap.getHeight() * 0.3), true);
        return resized;
    }

//    private Bitmap LogoPOSPrintbottom() {
//        PrintHelper photoPrinter = new PrintHelper(MainActivity.this);
//        photoPrinter.setScaleMode(PrintHelper.SCALE_MODE_FIT);
//        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.logo);
//        Bitmap resized = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * 0.3), (int) (bitmap.getHeight() * 0.3), true);
//        return resized;
//    }


    private void bindService() {
        mPalmPayUsdkKernel = PalmPayUsdkKernel.getInstance();
        mPalmPayUsdkKernel.connectPalmPayUsdk(this, new PalmPayUsdkKernel.ConnCallback() {
            @Override
            public void onServiceConnected() {
                Log.d(TAG, "Service connection successful");
                basicProvider = mPalmPayUsdkKernel.mBasicProvider;
                mCardProvider = mPalmPayUsdkKernel.mCardProvider;
                mPinPadProvider = mPalmPayUsdkKernel.mPinPadProvider;
                mEmvProvider = mPalmPayUsdkKernel.mEmvProvider;
                mSecurityProvider = mPalmPayUsdkKernel.mSecurityProvider;
                mPrinterProvider = mPalmPayUsdkKernel.mPrinterProvider;
                try {
                    initPos();
                } catch (RemoteException e) {
//                    sunmi.sunmiui.utils.LogUtil.e(TAG, e.getMessage());
                    Log.d(TAG,  e.getMessage());
                    e.printStackTrace();
                }
            }

            @Override
            public void onServiceDisconnected() {
                Log.d(TAG, "Service disconnected.");

                bindService();
            }

            @Override
            public void onNotFoundService() {

            }
        });
    }


    private void initPos() throws RemoteException {
        MainActivity.this.basicProvider.initPOS(new InitPOSListener.Stub() {
            @Override
            public void initPOSSuccess() throws RemoteException {
             Log.d(TAG, "Service initialization successful.");
                android.util.Log.d("TAG", "PRINT PALM STATNO");


            }

            @Override
            public void initPOSFailed(int errorCode, String errorMessage) throws RemoteException {
                Log.d(TAG, "Service initialization failed.");
            }
        });
    }

    private  void  printPlampay(){
        android.util.Log.d("TAG", "PRINT PALM STAT");


        Bundle textBundle = new Bundle();
        textBundle.putString(Constant.PrintKey.FONT, fontbold);
        textBundle.putString(Constant.PrintKey.ALIGN, alineStr);
        textBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        textBundle.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textnm = new Bundle();
        textnm.putString(Constant.PrintKey.FONT, fontbold);
        textnm.putString(Constant.PrintKey.ALIGN, alineLeft);
        textnm.putInt(Constant.PrintKey.BOLD, boldType);
        textnm.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textbold = new Bundle();
        textbold.putString(Constant.PrintKey.FONT, fontbold);
        textbold.putString(Constant.PrintKey.ALIGN, alineStr);
        textbold.putInt(Constant.PrintKey.BOLD, boldTtype);
        textbold.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle texlg = new Bundle();
        texlg.putString(Constant.PrintKey.FONT, fontlg);
        texlg.putString(Constant.PrintKey.ALIGN, alineStr);
        texlg.putInt(Constant.PrintKey.BOLD, 1);
        texlg.putInt(Constant.PrintKey.ITALIC, italicType);



        Bundle itemsBundle = new Bundle();
        itemsBundle.putString(Constant.PrintKey.FONT, fontbold);
        itemsBundle.putString(Constant.PrintKey.ALIGN, alineLeft);
        itemsBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        itemsBundle.putInt(Constant.PrintKey.ITALIC, italicType);
        try {
//            android.util.Log.d("TAG", "PRINT Bndoooo : "+mPrinterProvider.getStatus());
            mPrinterProvider.addText(textbold, "*** Web ECTS Order *** \n");

//            mPrinterProvider.addText(texlg, " COPY \n");

            mPrinterProvider.addPicture(textnm, LogoPOSPrint());
            mPrinterProvider.addText(textBundle,""+cmpn+ "");
            mPrinterProvider.addText(textBundle, ""+addres+"");
            mPrinterProvider.addText(textBundle, ""+addres1);
            mPrinterProvider.addText(textBundle, ""+addres2);
            mPrinterProvider.addText(textBundle ,""+addres3);
            mPrinterProvider.addText(textBundle, ""+addres4);
            mPrinterProvider.addText(textBundle, ""+addres5+"" );
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            mPrinterProvider.addText(textBundle, "Device Rental Details");
            mPrinterProvider.addText(textnm, "--------------------------------");

            mPrinterProvider.addText(textBundle, "DATE: "+saledate+"");

            mPrinterProvider.addText(textBundle, "Lease Number:"+"");
            mPrinterProvider.addText(texlg, ""+qr_code+"");

//                            if (receiptno==null){
//                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
//                            }else if (receiptno.equals("")){
//                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
//                            }else{
//                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
//                            }


            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            mPrinterProvider.addText(itemsBundle, "Company Name: "+customername+"");
            mPrinterProvider.addText(itemsBundle, "Destination: "+bordername+"");

//                            printerDevice.printText(format, fromDateRow+"\n");
//                            printerDevice.printText(format, toDateRow+"\n");
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
//                            printerDevice.printText(format, "Unit Number:"+"\n");

            mPrinterProvider.addText(texlg, "Unit Number: "+serialno+"");

//                            printerDevice.printText(format, ""+serialno+"\n");

            mPrinterProvider.addText(itemsBundle, "Slave"+"");
            for (int k = 0; k < slaves.length(); k++) {
                JSONObject items_obj = slaves.getJSONObject(k);
                String snn = items_obj.getString("serial_no");
                mPrinterProvider.addText(itemsBundle, "SN: "+snn+"");

            }


            mPrinterProvider.addText(itemsBundle, "Vehicle Reg: "+vehicleno+"");
            mPrinterProvider.addText(itemsBundle, "Chassis: "+chasis+"");
//            mPrinterProvider.addText(itemsBundle, "Trailer number: "+trailorno+"");
//            mPrinterProvider.addText(itemsBundle, "Container number: "+containerno+"");



            mPrinterProvider.addText(itemsBundle, "Driver name: "+driver_name+"");
            mPrinterProvider.addText(itemsBundle, "Driver phone: "+driver_number+"");


            mPrinterProvider.addText(itemsBundle, "Cash");

//            if (saletype.equals("3")){
//
//                mPrinterProvider.addText(itemsBundle, "Sale type : BILL"+"");
//            }else{
//                mPrinterProvider.addText(itemsBundle, "Sale type : "+ currency+"");
//                mPrinterProvider.addText(itemsBundle, "Amount: "+amount+ currency+"");
//            }






            mPrinterProvider.addText(itemsBundle, "Port point: "+portname+"");

            mPrinterProvider.addText(itemsBundle, "TZDL number: "+tzl+"");


            mPrinterProvider.addText(itemsBundle, "Passport: "+passport+"");
            mPrinterProvider.addText(itemsBundle, "Tagger: "+tagger+"");
            mPrinterProvider.addText(itemsBundle, "Start date : "+saledate+"");
            mPrinterProvider.addText(itemsBundle, "End date: "+enddate+"");


//                            printerDevice.printText(format, storeNmRow+"\n");
//                            printerDevice.printText(format, salePerRow+"\n");


            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

//            if (branchId==4){
//                printerDevice.printText(format, "Contact us:"+contacta+"\n");
//                printerDevice.printText(format, ""+contacta2+"\n");
//            }else {
//                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                printerDevice.printText(format, ""+contact2+"\n");
//            }





            if (branchId==4){
//                                printerDevice.printText(format, "Powered by:");
//                                printerDevice.printBitmap(format, LogoPOSPrintbottom());
            }else {
//                                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                                printerDevice.printText(format, ""+contact2+"\n");
            }


            mPrinterProvider.addText(textBundle, "Contact us:"+contact+"");
            mPrinterProvider.addText(textBundle, ""+contact2+"");

            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            Bundle qrCodeBundle = new Bundle();
            qrCodeBundle.putString(Constant.PrintKey.ALIGN, alineStr);
            qrCodeBundle.putInt(Constant.PrintKey.HEIGHT, 200);
            mPrinterProvider.addQrCode(qrCodeBundle,qr_code);
            mPrinterProvider.addText(textBundle, "*** END OF Web ECTS Order ***");
            mPrinterProvider.startPrinter(new PrinterListener.Stub() {
                @Override
                public void onError(int errorCode, String detail) {
                    android.util.Log.e(TAG, "errorCode：" + errorCode + "===detail：" + detail);
                }

                @Override
                public void onFinish() {
                    android.util.Log.e(TAG, "printer Finish");
                }
            });



            android.util.Log.d("TAG", "PRINT Bndoooo222");
        } catch (RemoteException e) {
            android.util.Log.d("TAGprint", e.toString());

        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    private  void  printPlampaycop(){
        android.util.Log.d("TAG", "PRINT PALM STAT");


        Bundle textBundle = new Bundle();
        textBundle.putString(Constant.PrintKey.FONT, fontbold);
        textBundle.putString(Constant.PrintKey.ALIGN, alineStr);
        textBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        textBundle.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textnm = new Bundle();
        textnm.putString(Constant.PrintKey.FONT, fontbold);
        textnm.putString(Constant.PrintKey.ALIGN, alineLeft);
        textnm.putInt(Constant.PrintKey.BOLD, boldType);
        textnm.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textbold = new Bundle();
        textbold.putString(Constant.PrintKey.FONT, fontbold);
        textbold.putString(Constant.PrintKey.ALIGN, alineStr);
        textbold.putInt(Constant.PrintKey.BOLD, boldTtype);
        textbold.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle texlg = new Bundle();
        texlg.putString(Constant.PrintKey.FONT, fontlg);
        texlg.putString(Constant.PrintKey.ALIGN, alineStr);
        texlg.putInt(Constant.PrintKey.BOLD, 1);
        texlg.putInt(Constant.PrintKey.ITALIC, italicType);



        Bundle itemsBundle = new Bundle();
        itemsBundle.putString(Constant.PrintKey.FONT, fontbold);
        itemsBundle.putString(Constant.PrintKey.ALIGN, alineLeft);
        itemsBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        itemsBundle.putInt(Constant.PrintKey.ITALIC, italicType);
        try {
//            android.util.Log.d("TAG", "PRINT Bndoooo : "+mPrinterProvider.getStatus());
            mPrinterProvider.addText(textbold, "*** Web ECTS Order ***\n");

            mPrinterProvider.addText(texlg, " COPY \n");

            mPrinterProvider.addPicture(textnm, LogoPOSPrint());
            mPrinterProvider.addText(textBundle,""+cmpn+ "");
            mPrinterProvider.addText(textBundle, ""+addres+"");
            mPrinterProvider.addText(textBundle, ""+addres1);
            mPrinterProvider.addText(textBundle, ""+addres2);
            mPrinterProvider.addText(textBundle ,""+addres3);
            mPrinterProvider.addText(textBundle, ""+addres4);
            mPrinterProvider.addText(textBundle, ""+addres5+"" );
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            mPrinterProvider.addText(textBundle, "Device Rental Details");
            mPrinterProvider.addText(textnm, "--------------------------------");

            mPrinterProvider.addText(textBundle, "DATE: "+saledate+"");

            mPrinterProvider.addText(textBundle, "Lease Number:"+"");
            mPrinterProvider.addText(texlg, ""+qr_code+"");

//                            if (receiptno==null){
//                                printerDevice.printText(format, "Lease Number:"+qr_code+"\n");
//                            }else if (receiptno.equals("")){
//                                printerDevice.printText(format, "Lease Number:"+offline_receiptno+"\n");
//                            }else{
//                                printerDevice.printText(format, "Lease Number:"+receiptno+"\n");
//                            }


            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            mPrinterProvider.addText(itemsBundle, "Company Name: "+customername+"");
            mPrinterProvider.addText(itemsBundle, "Destination: "+bordername+"");

//                            printerDevice.printText(format, fromDateRow+"\n");
//                            printerDevice.printText(format, toDateRow+"\n");
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
//                            printerDevice.printText(format, "Unit Number:"+"\n");

            mPrinterProvider.addText(texlg, "Unit Number: "+serialno+"");

//                            printerDevice.printText(format, ""+serialno+"\n");

            mPrinterProvider.addText(itemsBundle, "Slave"+"");
            for (int k = 0; k < slaves.length(); k++) {
                JSONObject items_obj = slaves.getJSONObject(k);
                String snn = items_obj.getString("serial_no");
                mPrinterProvider.addText(itemsBundle, "SN: "+snn+"");

            }


            mPrinterProvider.addText(itemsBundle, "Vehicle Reg: "+vehicleno+"");
            mPrinterProvider.addText(itemsBundle, "Chassis: "+chasis+"");
//            mPrinterProvider.addText(itemsBundle, "Trailer number: "+trailorno+"");
//            mPrinterProvider.addText(itemsBundle, "Container number: "+containerno+"");

            mPrinterProvider.addText(itemsBundle, "Driver name: "+driver_name+"");
            mPrinterProvider.addText(itemsBundle, "Driver phone: "+driver_number+"");



            mPrinterProvider.addText(itemsBundle, "Cash");
//            if (saletype.equals("3")){
//
//                mPrinterProvider.addText(itemsBundle, "Sale type : BILL"+"");
//            }else{
//                mPrinterProvider.addText(itemsBundle, "Sale type : "+ currency+"");
//                mPrinterProvider.addText(itemsBundle, "Amount: "+amount+ currency+"");
//            }






            mPrinterProvider.addText(itemsBundle, "Port point: "+portname+"");

            mPrinterProvider.addText(itemsBundle, "TZDL number: "+tzl+"");


            mPrinterProvider.addText(itemsBundle, "Passport: "+passport+"");
            mPrinterProvider.addText(itemsBundle, "Tagger: "+tagger+"");
            mPrinterProvider.addText(itemsBundle, "Start date : "+saledate+"");
            mPrinterProvider.addText(itemsBundle, "End date: "+enddate+"");


//                            printerDevice.printText(format, storeNmRow+"\n");
//                            printerDevice.printText(format, salePerRow+"\n");


            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

//            if (branchId==4){
//                printerDevice.printText(format, "Contact us:"+contacta+"\n");
//                printerDevice.printText(format, ""+contacta2+"\n");
//            }else {
//                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                printerDevice.printText(format, ""+contact2+"\n");
//            }





            if (branchId==4){
//                                printerDevice.printText(format, "Powered by:");
//                                printerDevice.printBitmap(format, LogoPOSPrintbottom());
            }else {
//                                printerDevice.printText(format, "Contact us:"+contact+"\n");
//                                printerDevice.printText(format, ""+contact2+"\n");
            }


            mPrinterProvider.addText(textBundle, "Contact us:"+contact+"");
            mPrinterProvider.addText(textBundle, ""+contact2+"");

            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            Bundle qrCodeBundle = new Bundle();
            qrCodeBundle.putString(Constant.PrintKey.ALIGN, alineStr);
            qrCodeBundle.putInt(Constant.PrintKey.HEIGHT, 200);
            mPrinterProvider.addQrCode(qrCodeBundle,qr_code);
            mPrinterProvider.addText(textBundle, "*** END OF Web ECTS Order ***");
            mPrinterProvider.startPrinter(new PrinterListener.Stub() {
                @Override
                public void onError(int errorCode, String detail) {
                    android.util.Log.e(TAG, "errorCode：" + errorCode + "===detail：" + detail);
                }

                @Override
                public void onFinish() {
                    android.util.Log.e(TAG, "printer Finish");
                }
            });



            android.util.Log.d("TAG", "PRINT Bndoooo222");
        } catch (RemoteException e) {
            android.util.Log.d("TAGprint", e.toString());

        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }



    private  void  printPOSDeviceReportPalm(){
        android.util.Log.d("TAG", "PRINT PALM STAT");


        Bundle textBundle = new Bundle();
        textBundle.putString(Constant.PrintKey.FONT, fontbold);
        textBundle.putString(Constant.PrintKey.ALIGN, alineStr);
        textBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        textBundle.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textnm = new Bundle();
        textnm.putString(Constant.PrintKey.FONT, fontbold);
        textnm.putString(Constant.PrintKey.ALIGN, alineLeft);
        textnm.putInt(Constant.PrintKey.BOLD, boldType);
        textnm.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle textbold = new Bundle();
        textbold.putString(Constant.PrintKey.FONT, fontbold);
        textbold.putString(Constant.PrintKey.ALIGN, alineStr);
        textbold.putInt(Constant.PrintKey.BOLD, boldTtype);
        textbold.putInt(Constant.PrintKey.ITALIC, italicType);

        Bundle texlg = new Bundle();
        texlg.putString(Constant.PrintKey.FONT, fontlg);
        texlg.putString(Constant.PrintKey.ALIGN, alineStr);
        texlg.putInt(Constant.PrintKey.BOLD, 1);
        texlg.putInt(Constant.PrintKey.ITALIC, italicType);



        Bundle itemsBundle = new Bundle();
        itemsBundle.putString(Constant.PrintKey.FONT, fontbold);
        itemsBundle.putString(Constant.PrintKey.ALIGN, alineLeft);
        itemsBundle.putInt(Constant.PrintKey.BOLD, boldTtype);
        itemsBundle.putInt(Constant.PrintKey.ITALIC, italicType);
        try {
//            android.util.Log.d("TAG", "PRINT Bndoooo : "+mPrinterProvider.getStatus());
            mPrinterProvider.addText(textbold, ".*** START OF REPORT ***");
            mPrinterProvider.addText(textbold, "");
            mPrinterProvider.addPicture(textbold, LogoPOSPrint());

            mPrinterProvider.addText(textbold, "");
            mPrinterProvider.addText(textbold, ""+addres+"");
            mPrinterProvider.addText(textbold, ""+addres1+"");
            mPrinterProvider.addText(textbold, ""+addres2+"");
            mPrinterProvider.addText(textbold, ""+addres3+"");
            mPrinterProvider.addText(textbold, ""+addres4+"");
            mPrinterProvider.addText(textbold, ""+addres5+"");
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            mPrinterProvider.addText(textbold, "Device Border Return Report");
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            mPrinterProvider.addText(itemsBundle, "Border:  "+border+"");
            mPrinterProvider.addText(itemsBundle, "StartDate:  "+startdate+"");
            mPrinterProvider.addText(itemsBundle, "EndDate:  "+enddate+"");
            mPrinterProvider.addText(itemsBundle, "User:   "+user+"");
            mPrinterProvider.addText(itemsBundle, "Total Device:  "+total+"");


            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            mPrinterProvider.addText(textbold, "Device List");
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");
            for (int k = 0; k < devices_array.length(); k++) {
                JSONObject items_obj = devices_array.getJSONObject(k);
                String snn = items_obj.getString("serial_no");
                mPrinterProvider.addText(itemsBundle, "SN: "+snn+"");

            }
            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            mPrinterProvider.addText(textbold, "Contact us:"+contact+"");
            mPrinterProvider.addText(textbold, ""+contact2+"");



            mPrinterProvider.addText(textnm, "" + "--------------------------------"+"");

            mPrinterProvider.addText(textBundle, "*** END OF RERPORT ***");
            mPrinterProvider.startPrinter(new PrinterListener.Stub() {
                @Override
                public void onError(int errorCode, String detail) {
                    android.util.Log.e(TAG, "errorCode：" + errorCode + "===detail：" + detail);
                }

                @Override
                public void onFinish() {
                    android.util.Log.e(TAG, "printer Finish");
                }
            });



            android.util.Log.d("TAG", "PRINT Bndoooo222");
        } catch (RemoteException e) {
            android.util.Log.d("TAGprint", e.toString());

        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }





}
