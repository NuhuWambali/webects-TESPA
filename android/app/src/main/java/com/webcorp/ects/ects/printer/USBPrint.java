package com.webcorp.ects.ects.printer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import androidx.print.PrintHelper;

import com.common.apiutil.printer.UsbThermalPrinter;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.transsnet.sdk.palmpayusdk.constant.Constant;
import com.webcorp.ects.MainActivity;
import com.webcorp.ects.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.Hashtable;
import java.util.Locale;

import io.flutter.plugin.common.MethodChannel;

public class USBPrint {

    Context mContext;
    UsbThermalPrinter mUsbThermalPrinter;
    private OnTPRINTERSuccessListener monTPRINTERSuccessListener;


    //    ######################################
    String itemsLoop;
    String customerIdType;
    JSONArray items_array;
    JSONObject sales_obj;

    //company data
    String company_name, company_mobile_number, company_tin, company_vrn, company_serial_no, company_address, company_uin, company_tax_office;

    //customer data
    String customer_name, customer_id_type, customer_id, customer_vrn, customer_mobile, customer_address;
    //Other Details
    String store_id, sales_ref_no, total, id, receipt_currency, date, cashierID;
    //Receipt detaiils
    String receipt_number, z_number, receipt_date, receipt_time;

    //Footer Section
    String receipt_v_code, qr_code;

    //summations
    String totalTax, totalExcl, totalIncl;

//salesdata


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
//    String receipt_v_code, qr_code;
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

    String receiptname,user,startdaten,enddaten,border,saletype;
    JSONArray devices_array,slaves;


    //mwishosales
    int lineCharacter = 27;

    public interface OnTPRINTERSuccessListener {
        void onTPRINTERSuccess(int data);
    }

    public USBPrint(Context context, OnTPRINTERSuccessListener onTPRINTERSuccessListener) {
        this.mContext = context;
        this.monTPRINTERSuccessListener=onTPRINTERSuccessListener;
        mUsbThermalPrinter = new UsbThermalPrinter(mContext);
        new Thread(() -> {
            try {
                mUsbThermalPrinter.start(0);
                String version = mUsbThermalPrinter.getVersion();
                int status = mUsbThermalPrinter.checkStatus();

                if (monTPRINTERSuccessListener != null)
                    monTPRINTERSuccessListener.onTPRINTERSuccess(status);

                Log.d("printer version---",version);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

    private Bitmap LogoPOSPrint() {



        PrintHelper photoPrinter = new PrintHelper(this.mContext);
        photoPrinter.setScaleMode(PrintHelper.SCALE_MODE_FIT);
        Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.logov);
        Bitmap resized = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * 0.5), (int) (bitmap.getHeight() * 0.5), true);
        return resized;

//        PrintHelper photoPrinter = new PrintHelper(this.mContext);
//        photoPrinter.setScaleMode(PrintHelper.SCALE_MODE_FIT);
////        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.frame6);
//        Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tra);
//        Bitmap resized = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * 0.5), (int) (bitmap.getHeight() * 0.5), true);
//        return resized;
    }

    public static String getTotalWhiteSpace(int size) {
        StringBuilder builder = new StringBuilder(size);
        for (int i = 0; i < size; i++) {
            builder.append(' ');
        }
        return builder.toString();
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
                io.flutter.Log.d("AMNAZO", receiptno);
                qr_code= receiptno;
                //qr_code = offline_receipt_number;
//                Log.d("Print opened mike nullu",qr_code.toString());

            }else{
                System.out.print ( "AMNA data");
                io.flutter.Log.d("AMNADATA", receiptno);
//                Log.d("Print else amana ipo",qr_code.toString());
//                qr_code= receiptno;
                qr_code = offline_receipt_number;
                io.flutter.Log.d("AMNA2", qr_code);
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

    public void printContent_58(JSONObject printData, MethodChannel.Result result){
        new Thread(() -> {
            try{
                JSONObject main_obj = new JSONObject(printData.toString());
                getSalesReportData(printData);


                mUsbThermalPrinter.reset();
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setGray(4);
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.setAlgin(0);
//                mUsbThermalPrinter.setTextSize(20);
//                mUsbThermalPrinter.addString("*** START OF LEGAL RECEIPT ***");
//                Bitmap barcode = CreateCode("12345678", BarcodeFormat.CODE_128, 320, 176);
//                if (barcode != null) mUsbThermalPrinter.printLogo(barcode, true);
//                Bitmap qrcode = CreateCode("12345678", BarcodeFormat.QR_CODE, 248, 248);
//                if (qrcode != null) mUsbThermalPrinter.printLogo(qrcode, true);

                mUsbThermalPrinter.addString(".*** Web ECTS Order ***");

                mUsbThermalPrinter.addString("");

//                Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tra);
                if(LogoPOSPrint() != null) mUsbThermalPrinter.printLogo(LogoPOSPrint(),true);
//                mUsbThermalPrinter.setTextSize(24);
                mUsbThermalPrinter.addString("");
                mUsbThermalPrinter.addString(cmpn);
                mUsbThermalPrinter.addString(addres);
                mUsbThermalPrinter.addString(addres1);
                mUsbThermalPrinter.addString(addres2);
                mUsbThermalPrinter.addString(addres3);
                mUsbThermalPrinter.addString(addres4);
                mUsbThermalPrinter.addString(addres5);

                mUsbThermalPrinter.addString("---------------------------");
                mUsbThermalPrinter.addString("Device Rental Details");
                mUsbThermalPrinter.addString("----------------------------");
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                mUsbThermalPrinter.addString("DATE: "+saledate+"");
                mUsbThermalPrinter.addString("Lease Number");

                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(25);
                mUsbThermalPrinter.addString(qr_code);
                mUsbThermalPrinter.setBold(false);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Company Name: "+ customername);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                mUsbThermalPrinter.addString("Destination: "+ bordername);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setTextSize(25);
                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.addString("Unit Number: "+ serialno);
                mUsbThermalPrinter.setBold(false);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);

                mUsbThermalPrinter.addString("Slave");
                mUsbThermalPrinter.setTextSize(22);


                for (int k = 0; k < slaves.length(); k++) {
                    JSONObject items_obj = slaves.getJSONObject(k);
                    String snn = items_obj.getString("serial_no");


                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                    mUsbThermalPrinter.addString("SN: "+snn);

                }



                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Vehicle Reg: "+vehicleno);
                mUsbThermalPrinter.addString("Chassis: "+chasis);
//                mUsbThermalPrinter.addString("Trailer number: "+trailorno);
//                mUsbThermalPrinter.addString("Container number: "+containerno);
                mUsbThermalPrinter.addString("Driver name: "+driver_name);
                mUsbThermalPrinter.addString("Driver phone: "+driver_number);



                //



                mUsbThermalPrinter.addString("Sales Type : Cash");
//                if (saletype.equals("3")){
//
//
//                    mUsbThermalPrinter.setTextSize(22);
//                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
//
//
//                    mUsbThermalPrinter.addString("Sale type : BILL");
//
//
//                }else{
//
//
//                    mUsbThermalPrinter.setTextSize(22);
//                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
//
//
//                    mUsbThermalPrinter.addString("Sale type : "+ currency);
//
//
//
//                    mUsbThermalPrinter.addString("Amount: "+amount+ currency);
//                }






                mUsbThermalPrinter.setTextSize(20);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Port point: "+portname);
                mUsbThermalPrinter.addString("TZDL number: "+tzl);
                mUsbThermalPrinter.addString("Passport: "+passport);
                mUsbThermalPrinter.addString("Tagger: "+tagger);
                mUsbThermalPrinter.addString("Start date : "+saledate);
                mUsbThermalPrinter.addString("End date: "+enddate);

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                if (branchId==4){
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contacta);
                    mUsbThermalPrinter.addString(contacta2);

                }else {
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contact);
                    mUsbThermalPrinter.addString(contact2);

                }
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setTextSize(22);
//                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);

                Bitmap qrcode = CreateCode(qr_code, BarcodeFormat.QR_CODE, 150, 150);
                if (qrcode != null) mUsbThermalPrinter.printLogo(qrcode, true);
//                mUsbThermalPrinter.addStringOneLine("--------------------------------");

                mUsbThermalPrinter.setTextSize(22);

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);

                mUsbThermalPrinter.addString("*** END OF Web ECTS Order ***");

                mUsbThermalPrinter.printString();
                mUsbThermalPrinter.walkPaper(20);
            }catch (Exception e){
                e.printStackTrace();
            }
        }).start();
    }




    public void printContent_58cop(JSONObject printData, MethodChannel.Result result){
        new Thread(() -> {
            try{
                JSONObject main_obj = new JSONObject(printData.toString());
                getSalesReportData(printData);


                mUsbThermalPrinter.reset();
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setGray(4);
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.setAlgin(0);
//                mUsbThermalPrinter.setTextSize(20);
//                mUsbThermalPrinter.addString("*** START OF LEGAL RECEIPT ***");
//                Bitmap barcode = CreateCode("12345678", BarcodeFormat.CODE_128, 320, 176);
//                if (barcode != null) mUsbThermalPrinter.printLogo(barcode, true);
//                Bitmap qrcode = CreateCode("12345678", BarcodeFormat.QR_CODE, 248, 248);
//                if (qrcode != null) mUsbThermalPrinter.printLogo(qrcode, true);

                mUsbThermalPrinter.addString(".*** Web ECTS Order ***");


                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.addString("COPY");
                mUsbThermalPrinter.setBold(false);
                mUsbThermalPrinter.addString("");

//                Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tra);
                if(LogoPOSPrint() != null) mUsbThermalPrinter.printLogo(LogoPOSPrint(),true);
//                mUsbThermalPrinter.setTextSize(24);
                mUsbThermalPrinter.addString("");
//                Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tra);

//                mUsbThermalPrinter.setTextSize(24);
                mUsbThermalPrinter.addString(cmpn);
                mUsbThermalPrinter.addString(addres);
                mUsbThermalPrinter.addString(addres1);
                mUsbThermalPrinter.addString(addres2);
                mUsbThermalPrinter.addString(addres3);
                mUsbThermalPrinter.addString(addres4);
                mUsbThermalPrinter.addString(addres5);

                mUsbThermalPrinter.addString("---------------------------");
                mUsbThermalPrinter.addString("Device Rental Details");
                mUsbThermalPrinter.addString("----------------------------");
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                mUsbThermalPrinter.addString("DATE: "+saledate+"");
                mUsbThermalPrinter.addString("Lease Number");

                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(25);
                mUsbThermalPrinter.addString(qr_code);
                mUsbThermalPrinter.setBold(false);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Company Name: "+ customername);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                mUsbThermalPrinter.addString("Destination: "+ bordername);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setTextSize(25);
                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.addString("Unit Number: "+ serialno);
                mUsbThermalPrinter.setBold(false);

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);

                mUsbThermalPrinter.addString("Slave");
                mUsbThermalPrinter.setTextSize(22);


                for (int k = 0; k < slaves.length(); k++) {
                    JSONObject items_obj = slaves.getJSONObject(k);
                    String snn = items_obj.getString("serial_no");


                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                    mUsbThermalPrinter.addString("SN: "+snn);

                }



                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Vehicle Reg: "+vehicleno);
                mUsbThermalPrinter.addString("Chassis: "+chasis);
//                mUsbThermalPrinter.addString("Trailer number: "+trailorno);
//                mUsbThermalPrinter.addString("Container number: "+containerno);
                mUsbThermalPrinter.addString("Driver name: "+driver_name);
                mUsbThermalPrinter.addString("Driver phone: "+driver_number);



                //




//                if (saletype.equals("3")){
//
//
//                    mUsbThermalPrinter.setTextSize(22);
//                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
//
//
//                    mUsbThermalPrinter.addString("Sale type : BILL");
//
//
//                }else{
//
//
//                    mUsbThermalPrinter.setTextSize(22);
//                    mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
//
//
//                    mUsbThermalPrinter.addString("Sale type : "+ currency);
//
//
//
//                    mUsbThermalPrinter.addString("Amount: "+amount+ currency);
//                }



                mUsbThermalPrinter.addString("Sales Type : Cash");


                mUsbThermalPrinter.setTextSize(20);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Port point: "+portname);
                mUsbThermalPrinter.addString("TZDL number: "+tzl);
                mUsbThermalPrinter.addString("Passport: "+passport);
                mUsbThermalPrinter.addString("Tagger: "+tagger);
                mUsbThermalPrinter.addString("Start date : "+saledate);
                mUsbThermalPrinter.addString("End date: "+enddate);

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                if (branchId==4){
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contacta);
                    mUsbThermalPrinter.addString(contacta2);

                }else {
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contact);
                    mUsbThermalPrinter.addString(contact2);

                }
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setTextSize(22);
//                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);

                Bitmap qrcode = CreateCode(qr_code, BarcodeFormat.QR_CODE, 150, 150);
                if (qrcode != null) mUsbThermalPrinter.printLogo(qrcode, true);
//                mUsbThermalPrinter.addStringOneLine("--------------------------------");

                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setBold(true);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.addString("COPY");
                mUsbThermalPrinter.setBold(false);
                mUsbThermalPrinter.addString("*** END OF Web ECTS Order ***");

                mUsbThermalPrinter.printString();
                mUsbThermalPrinter.walkPaper(20);
            }catch (Exception e){
                e.printStackTrace();
            }
        }).start();
    }



    public void printContentdevice(JSONObject printData, MethodChannel.Result result){
        new Thread(() -> {
            try{
                JSONObject main_obj = new JSONObject(printData.toString());
                getDeviceReportData(printData);


                mUsbThermalPrinter.reset();
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.setGray(4);
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.addString("\n");
//                mUsbThermalPrinter.setAlgin(0);
//                mUsbThermalPrinter.setTextSize(20);
//                mUsbThermalPrinter.addString("*** START OF LEGAL RECEIPT ***");
//                Bitmap barcode = CreateCode("12345678", BarcodeFormat.CODE_128, 320, 176);
//                if (barcode != null) mUsbThermalPrinter.printLogo(barcode, true);
//                Bitmap qrcode = CreateCode("12345678", BarcodeFormat.QR_CODE, 248, 248);
//                if (qrcode != null) mUsbThermalPrinter.printLogo(qrcode, true);

                mUsbThermalPrinter.addString(".*** START OF REPORT ***");


                mUsbThermalPrinter.addString("");

//                Bitmap bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tra);
                if(LogoPOSPrint() != null) mUsbThermalPrinter.printLogo(LogoPOSPrint(),true);
//                mUsbThermalPrinter.setTextSize(24);
                mUsbThermalPrinter.addString("");
                mUsbThermalPrinter.addString(cmpn);
                mUsbThermalPrinter.addString(addres);
                mUsbThermalPrinter.addString(addres1);
                mUsbThermalPrinter.addString(addres2);
                mUsbThermalPrinter.addString(addres3);
                mUsbThermalPrinter.addString(addres4);
                mUsbThermalPrinter.addString(addres5);

                mUsbThermalPrinter.addString("---------------------------");



                mUsbThermalPrinter.addString("Device Border Return Report");
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");
                mUsbThermalPrinter.addString("Border:  "+border);
                mUsbThermalPrinter.addString("StartDate:  "+startdate);
                mUsbThermalPrinter.addString("EndDate:  "+enddate);
                mUsbThermalPrinter.addString("User:   "+user);
                mUsbThermalPrinter.addString("Total Device:  "+total);




                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                mUsbThermalPrinter.setTextSize(20);
                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);


                mUsbThermalPrinter.addString("Device List");
                mUsbThermalPrinter.addString("----------------------------");
                for (int k = 0; k < devices_array.length(); k++) {
                    JSONObject items_obj = devices_array.getJSONObject(k);
                    String snn = items_obj.getString("serial_no");
                    mUsbThermalPrinter.addString("SN: "+snn);

                }
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");

                if (branchId==4){
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contacta);
                    mUsbThermalPrinter.addString(contacta2);

                }else {
                    mUsbThermalPrinter.setTextSize(22);
                    mUsbThermalPrinter.addString("Contact us:"+contact);
                    mUsbThermalPrinter.addString(contact2);

                }
                mUsbThermalPrinter.setTextSize(22);
                mUsbThermalPrinter.addString("----------------------------");


                mUsbThermalPrinter.setTextSize(22);

                mUsbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);

                mUsbThermalPrinter.addString("*** END OF RERPORT ***");

                mUsbThermalPrinter.printString();
                mUsbThermalPrinter.walkPaper(20);







            }catch (Exception e){
                e.printStackTrace();
            }
        }).start();
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


    public void printContent_80(){

    }

    public void closePrinter(){
        try {
            if(mUsbThermalPrinter != null) mUsbThermalPrinter.stop();
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public Bitmap CreateCode(String str, BarcodeFormat type, int bmpWidth, int bmpHeight)
            throws WriterException {
        Hashtable<EncodeHintType, String> mHashtable = new Hashtable<EncodeHintType, String>();
        mHashtable.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        BitMatrix matrix = new MultiFormatWriter().encode(str, type, bmpWidth, bmpHeight, mHashtable);
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        int[] pixels = new int[width * height];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                if (matrix.get(x, y)) {
                    pixels[y * width + x] = 0xff000000;
                } else {
                    pixels[y * width + x] = 0xffffffff;
                }
            }
        }
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
        return bitmap;
    }
}
