import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import UserLogin from './user/userLogin'

class Home extends React.Component {
  constructor(props){
     super(props);

     this.state = {};
  }

  currentUser () {
    return(this.state.currentUser)
  }

  setUser (user) {
    this.setState({currentUser: user})
  }

  logOut() {
    this.setState({currentUser: null})
  }

  renderPage () {
    if (this.currentUser() == null) {
      return(<UserLogin setUser={this.setUser.bind(this)}/>);
    } else {
      return(
        <div className='main-content'>
          <h1>Welcome {this.currentUser().name}</h1>
          <button onClick={this.logOut.bind(this)}>
            Log Out
          </button>
        </div>
      );
    }
  }

  render() {
    return(this.renderPage());
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // const data = JSON.parse(node.getAttribute('data'));
  ReactDOM.render(
    <Home/>,
    document.body.appendChild(document.createElement('div')),
  )
})