const express = require('express');
const { RtcTokenBuilder, RtcRole } = require('agora-access-token');

const app = express();
const port = 3000;

// Your Agora credentials
const APP_ID = '84220a4dc86144bb9457af1cd9965016';
const APP_CERTIFICATE = '6e0eada1fb14453185bb84c8cd845e55';

// Endpoint to generate token
app.get('/api/token', (req, res) => {
    const channelName = req.query.channel || 'default';
    const uid = req.query.uid || 0;
    const role = RtcRole.PUBLISHER;
    const expirationTimeInSeconds = 3600; // 1 hour

    const token = RtcTokenBuilder.buildTokenWithUid(APP_ID, APP_CERTIFICATE, channelName, uid, role, expirationTimeInSeconds);

    res.json({ token });
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
