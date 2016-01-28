---
layout: post
title: "May I have some Marshmallows, please?"
date: 2016-01-28 03:05:30
description: Quick update on using the new runtime permissions on Android 6.0 (Marshmallow)
permalink: /posts/marshmallow-permissions
tags: [android, tips]
excerpt: "Quick update on using the new runtime permissions on Android 6.0 (Marshmallow)"
comments: true
---

<p align="center">
	<img src="/img/android–marshmallow.png">
</p>

After a long wait, my AndroidOne finally got it’s Marshmallow update yesterday.
I finally got a hands on experience of the not-so-new OS, and I must confess,
I love it! I love the ‘Now on tap’, the ‘DND’ mode, and one of my favourite parts
of the update - the new permissions feature.

With the new permissions, users now have more control over permissions that apps have.
Like in iOS, users can specifically turn off certain permissions like access to contacts,
locations etc. So, if you’ve built your app previously to request for permission
to use the camera for example, if users turn off that permission for your app,
that functionality will fail. Check [*here*](https://www.google.com/design/spec/patterns/permissions.html)
 if you want to see more about the ‘new’ permissions in Android M.

This has been out for a while now and, but I thought to put out some tips here for
 developers yet to update their apps for Android Marshmallow.

 According to Nick Butcher in [*this*](https://www.youtube.com/watch?v=iZqDdvhTZj0)
 video, the primary purpose of permission, is to protect your users' privacy.
 Runtime permissions allow you to choose the right time to ask for permission when
  the user has more context about why you’re asking and why they need to grant it.
He also described the UX best practices with runtime permissions. I suggest that
 you check out the video. He talked about determining your permission requirements by
 how important (critical or not) the permission is to your app, and how clear the
need for that permission is.

- Critical and clear: e.g SMS permission in an SMS app, or Camera permission in a Camera app.
This is critical to app functionality and hence, it's good to request for this permission at the beginning.

- Critical and unclear: when the feature is important, but not immediately obvious.
You should educate the users upfront before requesting for permission. Secondary and
not clear: offer some explanation and then allow the users opt-in and then should you request.

- Secondary and clear: If a secondary feature that is clear, you should ask in context.
No need to ask too early. Better to wait till when they try to use the feature,
when the purpose becomes clear.

- Secondary and not clear: For a secondary feature that is not really obvious,
ask for permission only when the user attempts to use that feature.


## Please allow me.
So, let's say we're making a new really cool app and we want to - say scan a QR code.


We obviously need the `android:name="android.permission.CAMERA"` permission, so
we add it to our AndroidManifest.xml as usual.

So, before we launch the camera, we do a check like:
    {% highlight java %}
    if(ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED) {
        //if permission is not granted.
        if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
            //this is an utility method to handle case where the user has previously declined.
            //you may need to show an explanation.
            Snackbar.make(mCameraPreview, "You need to enable this app to access your camera",
                    Snackbar.LENGTH_INDEFINITE).setAction("Settings", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    //open settings
                    showInstalledAppDetails(getApplicationContext(), getPackageName());
                }
            }).show();
        } else {
            //request for permission. You can listen for a response via onRequestPermissionsResult method.
            //note that REQUEST_PERMISSION_CAMERA is just an int request code taht we'll use to listen for the response
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, REQUEST_PERMISSION_CAMERA);
        }
    } else {
        //if permission is granted.
        //do stuff with the camera
    }
    {% endhighlight %}

Note that to use this from a fragment, you need to call `shouldShowRequestPermissionRationale` and `requestPermissions`
straight form the fragment.

## Now that we've asked
Now that we've asked for permission, we should be able to find out whether the
user has granted permission or not. Thank goodness, Android already has a callback method [`onRequestPermissionsResult`](http://developer.android.com/reference/android/support/v4/app/ActivityCompat.OnRequestPermissionsResultCallback.html#onRequestPermissionsResult(int, java.lang.String[], int[]))

{% highlight java %}
  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
      if(requestCode == REQUEST_PERMISSION_CAMERA) {
          //for the camera permission request
          //check if the grantResults array is not empty and it contains PackageManager.PERMISSION_GRANTED
          if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
              //openCamera
              openAndAttachCamera();
          } else{
              //permission has been denied. Disable the feature.
          }
      } else {
          super.onRequestPermissionsResult(requestCode, permissions, grantResults);
      }
  }
{% endhighlight %}

## Anddd that's it.
Now, you know how to work with runtime permissions.
Things change very fast with Android, always be sure to check out [https://developer.android.com](https://developer.android.com) and [https://android-developers.blogspot.com](https://android-developers.blogspot.com) for latest info.

In case you need a full app demo for this, check the source here: [https://github.com/segunfamisa/MarshmallowPermissions](https://github.com/segunfamisa/MarshmallowPermissions).

Please share and drop any comments in the comments section below.
Thanks for reading :)
