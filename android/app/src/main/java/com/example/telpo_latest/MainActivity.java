package com.example.telpo_latest;

import androidx.annotation.NonNull;

import com.telpo.tps550.api.fingerprint.FingerPrint;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.graphics.Bitmap;
import android.os.Bundle;
import com.common.devicestatus.sdk.DeviceStatus;

import com.suprema.BioMiniFactory;
import com.suprema.CaptureResponder;
import com.suprema.IBioMiniDevice;



public class MainActivity extends FlutterActivity {

    private  static final String CHANNEL = "flutter.native/telpo";

    private BioMiniFactory mBioMiniFactory;
    public IBioMiniDevice mCurrentDevice;
    private IBioMiniDevice.TemplateData mTemplateData;
    private IBioMiniDevice.CaptureOption mCaptureOption = new IBioMiniDevice.CaptureOption();



    CaptureResponder mCaptureCallBack = new CaptureResponder() {
        @Override
        public void onCapture(Object context, IBioMiniDevice.FingerState fingerState) {
            super.onCapture(context, fingerState);
        }
    };

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getDeviceStatus")) {
                           getDeviceStatus(call,result);
                        }
                        if (call.method.equals("fingerprint_on")) {
                            turnOnFingerprint(call,result);
                        }
                        if (call.method.equals("fingerprint_off")) {
                            turnOffFingerprint(call,result);
                        }
                        if (call.method.equals("is_capturing")) {
                            captureSingleFingerprint(call,result);
                        }
                    }});
    }

    private void getDeviceStatus(MethodCall call, MethodChannel.Result result) {
        int fpStatus = DeviceStatus.getFpStatus(getApplicationContext());
        result.success(fpStatus);
    }

    private void turnOnFingerprint(MethodCall call, MethodChannel.Result result){
        FingerPrint.fingerPrintPower(1);
        result.success(1);
    }

    private void turnOffFingerprint(MethodCall call, MethodChannel.Result result){
        FingerPrint.fingerPrintPower(0);
        result.success(0);
    }

    private void captureSingleFingerprint(MethodCall call, MethodChannel.Result result){
     boolean data =   doSingleCapture()
;        result.success(data);
//        if (mCurrentDevice.isCapturing() == true) {
//          result.success("isCapturing True");
//        }
//        boolean data =  doSingleCapture();
//        result.success(data);
    }

   private boolean doSingleCapture(){
        if (mCurrentDevice != null) {
            boolean data = mCurrentDevice.captureSingle(
                    mCaptureOption,
                    mCaptureCallBack,
                    true);
            return true;
        }
        else{
            return false;
        }
    }
}
