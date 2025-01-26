import React, { useState } from 'react';

const ChatComponent = () => {
  const [modalOpen, setModalOpen] = useState(false);

  const toggleModal = () => {
    setModalOpen(!modalOpen);
  };

  return React.createElement(
    'div',
    { style: { display: 'flex', height: '100vh' } },
    // Left Panel - Chat List
    React.createElement(
      'div',
      { style: { width: '25%', backgroundColor: '#f7fafc', borderRight: '1px solid #e2e8f0', display: 'flex', flexDirection: 'column' } },
      React.createElement(
        'div',
        { style: { padding: '16px', borderBottom: '1px solid #e2e8f0' } },
        React.createElement('h2', { style: { fontSize: '1.25rem', fontWeight: 600 } }, 'Chats')
      ),
      React.createElement(
        'div',
        { style: { flex: 1, overflowY: 'auto' } },
        // Dummy Chat List
        React.createElement(
          'div',
          { style: { padding: '16px', backgroundColor: '#e2e8f0', cursor: 'pointer' } },
          React.createElement('div', { style: { fontWeight: 500 } }, 'John Doe'),
          React.createElement(
            'div',
            { style: { fontSize: '0.875rem', color: '#718096', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' } },
            'Hello, how are you?'
          )
        ),
        React.createElement(
          'div',
          { style: { padding: '16px', cursor: 'pointer' } },
          React.createElement('div', { style: { fontWeight: 500 } }, 'Jane Smith'),
          React.createElement(
            'div',
            { style: { fontSize: '0.875rem', color: '#718096', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' } },
            'Are we still on for tomorrow?'
          )
        ),
        React.createElement(
          'div',
          { style: { padding: '16px', cursor: 'pointer' } },
          React.createElement('div', { style: { fontWeight: 500 } }, 'David Lee'),
          React.createElement(
            'div',
            { style: { fontSize: '0.875rem', color: '#718096', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' } },
            'No messages yet'
          )
        )
      )
    ),

    // Right Panel - Chat Messages
    React.createElement(
      'div',
      { style: { flex: 1, display: 'flex', flexDirection: 'column' } },
      // Chat Header
      React.createElement(
        'div',
        { style: { padding: '16px', borderBottom: '1px solid #e2e8f0', display: 'flex', justifyContent: 'space-between', alignItems: 'center' } },
        React.createElement('div', null, React.createElement('h3', { style: { fontSize: '1.125rem', fontWeight: 600 } }, 'John Doe')),
        React.createElement(
          'button',
          { style: { color: '#718096', cursor: 'pointer' }, onClick: toggleModal },
          React.createElement('svg', { style: { width: '20px', height: '20px' }, fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' },
            React.createElement('path', { strokeLinecap: 'round', strokeLinejoin: 'round', strokeWidth: '2', d: 'M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z' })
          )
        )
      ),

      // Messages Container
      React.createElement(
        'div',
        { style: { flex: 1, overflowY: 'auto', padding: '16px', display: 'flex', flexDirection: 'column', gap: '16px' } },
        React.createElement(
          'div',
          { style: { display: 'flex', justifyContent: 'flex-start' } },
          React.createElement(
            'div',
            { style: { backgroundColor: '#e2e8f0', borderRadius: '0.5rem', padding: '8px 16px', maxWidth: '75%' } },
            React.createElement('div', { style: { fontSize: '0.875rem' } }, 'Hello! How\'s it going?'),
            React.createElement('div', { style: { fontSize: '0.75rem', color: '#718096', marginTop: '4px' } }, '10:30 AM')
          )
        ),
        React.createElement(
          'div',
          { style: { display: 'flex', justifyContent: 'flex-end' } },
          React.createElement(
            'div',
            { style: { backgroundColor: '#4299e1', color: 'white', borderRadius: '0.5rem', padding: '8px 16px', maxWidth: '75%' } },
            React.createElement('div', { style: { fontSize: '0.875rem' } }, 'I\'m doing well, thanks!'),
            React.createElement('div', { style: { fontSize: '0.75rem', color: '#bee3f8', marginTop: '4px' } }, '10:32 AM')
          )
        ),
        React.createElement(
          'div',
          { style: { display: 'flex', justifyContent: 'flex-start' } },
          React.createElement(
            'div',
            { style: { backgroundColor: '#e2e8f0', borderRadius: '0.5rem', padding: '8px 16px', maxWidth: '75%' } },
            React.createElement('div', { style: { fontSize: '0.875rem' } }, 'Great to hear!'),
            React.createElement('div', { style: { fontSize: '0.75rem', color: '#718096', marginTop: '4px' } }, '10:35 AM')
          )
        )
      ),

      // Message Input
      React.createElement(
        'div',
        { style: { padding: '16px', borderTop: '1px solid #e2e8f0' } },
        React.createElement(
          'form',
          { style: { display: 'flex', gap: '8px' } },
          React.createElement('input', { type: 'text', style: { flex: 1, borderRadius: '0.5rem', border: '1px solid #e2e8f0', padding: '8px 16px', outline: 'none', borderColor: '#4299e1' }, placeholder: 'Type your message...' }),
          React.createElement(
            'button',
            { type: 'button', style: { backgroundColor: '#4299e1', color: 'white', padding: '8px 16px', borderRadius: '0.5rem', cursor: 'pointer' } },
            'Send'
          )
        )
      )
    ),

    // Chat Modal
    modalOpen && React.createElement(
      'div',
      { style: { display: 'flex', position: 'fixed', inset: '0', backgroundColor: 'rgba(0, 0, 0, 0.5)', alignItems: 'center', justifyContent: 'center' } },
      React.createElement(
        'div',
        { style: { backgroundColor: 'white', borderRadius: '0.5rem', width: '24rem', padding: '24px' } },
        React.createElement(
          'div',
          { style: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' } },
          React.createElement('h3', { style: { fontSize: '1.125rem', fontWeight: 600 } }, 'Chat Settings'),
          React.createElement(
            'button',
            { style: { color: '#718096', cursor: 'pointer' }, onClick: toggleModal },
            React.createElement('svg', { style: { width: '20px', height: '20px' }, fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' },
              React.createElement('path', { strokeLinecap: 'round', strokeLinejoin: 'round', strokeWidth: '2', d: 'M6 18L18 6M6 6l12 12' })
            )
          )
        ),

        // Modal Content
        React.createElement(
          'div',
          { style: { display: 'flex', flexDirection: 'column', gap: '16px' } },
          React.createElement(
            'div',
            null,
            React.createElement('label', { style: { display: 'block', fontSize: '0.875rem', fontWeight: 500, color: '#4a5568' } }, 'Chat Name'),
            React.createElement('input', { type: 'text', style: { marginTop: '4px', display: 'block', width: '100%', borderRadius: '0.375rem', border: '1px solid #e2e8f0', padding: '8px 16px', outline: 'none', borderColor: '#4299e1' } })
          ),
          React.createElement(
            'div',
            null,
            React.createElement('label', { style: { display: 'block', fontSize: '0.875rem', fontWeight: 500, color: '#4a5568' } }, 'Notifications'),
            React.createElement(
              'select',
              { style: { marginTop: '4px', display: 'block', width: '100%', borderRadius: '0.375rem', border: '1px solid #e2e8f0', padding: '8px 16px', outline: 'none', borderColor: '#4299e1' } },
              React.createElement('option', { value: 'all' }, 'All messages'),
              React.createElement('option', { value: 'mentions' }, 'Mentions only'),
              React.createElement('option', { value: 'none' }, 'None')
            )
          )
        ),

        React.createElement(
          'div',
          { style: { marginTop: '24px', display: 'flex', justifyContent: 'flex-end', gap: '12px' } },
          React.createElement(
            'button',
            { style: { padding: '8px 16px', border: '1px solid #e2e8f0', borderRadius: '0.375rem', color: '#4a5568', cursor: 'pointer' } },
            'Cancel'
          ),
          React.createElement(
            'button',
            { style: { padding: '8px 16px', backgroundColor: '#4299e1', color: 'white', borderRadius: '0.375rem', cursor: 'pointer' } },
            'Save Changes'
          )
        )
      )
    )
  );
};

export default ChatComponent;
