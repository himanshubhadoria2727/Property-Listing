<video id="localVideo" autoplay muted></video>
<video id="remoteVideo" autoplay></video>

<script>
   const localVideo = document.getElementById('localVideo');
   const remoteVideo = document.getElementById('remoteVideo');
   const peerConnection = new RTCPeerConnection();
   let localStream;

   // Get local media stream (camera and microphone)
   navigator.mediaDevices.getUserMedia({ video: true, audio: true }).then(stream => {
       localStream = stream;
       localVideo.srcObject = stream;
       stream.getTracks().forEach(track => peerConnection.addTrack(track, stream));
   });

   // Listen for ICE candidates
   peerConnection.onicecandidate = event => {
       if (event.candidate) {
           sendSignal({ type: 'candidate', data: event.candidate });
       }
   };

   // Handle remote stream
   peerConnection.ontrack = event => {
       remoteVideo.srcObject = event.streams[0];
   };

   // Setup signaling
   const sendSignal = signal => {
       fetch('/send-signal', {
           method: 'POST',
           headers: { 'Content-Type': 'application/json' },
           body: JSON.stringify(signal)
       });
   };

   // Listen for signaling messages (e.g., through Pusher)
   Echo.channel('property-channel').listen('Signal', (event) => {
       if (event.type === 'offer') {
           peerConnection.setRemoteDescription(new RTCSessionDescription(event.data));
           peerConnection.createAnswer().then(answer => {
               peerConnection.setLocalDescription(answer);
               sendSignal({ type: 'answer', data: answer });
           });
       } else if (event.type === 'answer') {
           peerConnection.setRemoteDescription(new RTCSessionDescription(event.data));
       } else if (event.type === 'candidate') {
           peerConnection.addIceCandidate(new RTCIceCandidate(event.data));
       }
   });

   // Create an offer to start a call
   peerConnection.createOffer().then(offer => {
       peerConnection.setLocalDescription(offer);
       sendSignal({ type: 'offer', data: offer });
   });
</script>
