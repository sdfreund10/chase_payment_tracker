import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

class Home extends React.Component {
  render() {
    return(
      <div><p>Hello, rails</p></div>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // const data = JSON.parse(node.getAttribute('data'));
  ReactDOM.render(
    <Home/>,
    document.body.appendChild(document.createElement('div')),
  )
})