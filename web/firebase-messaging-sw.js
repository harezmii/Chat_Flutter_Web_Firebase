
importScripts("https://www.gstatic.com/firebasejs/8.5.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.5.0/firebase-messaging.js");

var firebaseConfig = {
    apiKey: "AIzaSyDdCmluqJq_Sejbk_mD1_LrU-vQLM5fF58",
    authDomain: "ceheto-99413.firebaseapp.com",
    projectId: "ceheto-99413",
    storageBucket: "ceheto-99413.appspot.com",
    messagingSenderId: "499237680606",
    appId: "1:499237680606:web:18cd498ae139985fb1994f"
  };

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.requestPermission();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});