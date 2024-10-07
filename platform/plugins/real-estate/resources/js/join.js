import React, { useState, useEffect } from 'react';
import AgoraUIKit from 'agora-react-uikit';

const LiveBroadcast = () => {
    const [videoCall, setVideoCall] = useState(true);
    const token='007eJxTYDh09Ij+k1L/exW3Qi+XXSrlSeP9s8lgx93gk5UcpaHz7x1QYLAwMTIySDRJSbYwMzQxSUqyNDE1T0wzTE6xtDQzNTA0e8HyM60hkJHh5SwBRkYGCATxBRhyK3UT0/OLEnWTMxLz8lJzGBgAsmAl+w=='

    const fetchToken = async () => {
        try {
            const response = await fetch(`/token?channel=my-agora-channel&uid=0`);
            const data = await response.json();
            setToken(data.token);
        } catch (error) {
            console.error('Error fetching token:', error);
        }
    };

    // useEffect(() => {
    //     fetchToken();
    // }, [])
    
    return videoCall && token ? (`
        <div style={{ width: '100%', height: '100vh' }}>
            <AgoraUIKit rtcProps={rtcProps} callbacks={callbacks} />
        </div>`
    ) : (  `
        <h3>Loading...</h3>`
    );
};

export default LiveBroadcast;

