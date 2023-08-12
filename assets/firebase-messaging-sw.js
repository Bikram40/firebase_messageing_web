importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
const baseDir = location.pathname.replace("assets/packages/firebase_messaging_web/assets/firebase-messaging-sw.js","");
importScripts(baseDir + 'firebase-config.js');

self.addEventListener('notificationclick', function(event) {
  var tag = event.notification.tag;
  var evt = new CustomEvent('on_tap_notification', { detail: { tag: tag } }); // modify the event creation to pass the tag in the detail property
  event.notification.close();
  event.waitUntil(
    clients.matchAll({
      type: 'window',
      includeUncontrolled: true
    }).then(function(clientList) {
    if(clientList.length>0){
    clientList[0].focus();
              return;
    }
      clients.openWindow('/').then(function(windowClient) {
                                 // Wait for the new window to load and send the event
                                  windowClient.focus();
                                  windowClient.addEventListener('load', function() {
                                    windowClient.dispatchEvent(evt);
                                  });
                               }); // if no client matches, open a new window
    })
  );
});

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage(function(payload) {
const uniqueTag = new Date().getTime().toString(); // generate a unique tag using timestamp
const modifiedPayload = {...payload, notification: {...payload.notification, tag: uniqueTag}}; // include the unique tag in the notification object
const notificationTitle = modifiedPayload.notification.title;
  const notificationOptions = {
    body: modifiedPayload.notification.body,
    tag: uniqueTag // Unique tag for the notification
  };
 console.log('Received background message ', modifiedPayload);
    const promiseChain = self.clients
                .matchAll({
            type: "window",
            includeUncontrolled: true,
        })
                .then((windowClients) => {
                    for (let i = 0; i < windowClients.length; i++) {
                    const windowClient = windowClients[i];
                    windowClient.postMessage(modifiedPayload);
                }
                })
        .then(() => {
 self.registration.showNotification(notificationTitle, notificationOptions);

        });
  });