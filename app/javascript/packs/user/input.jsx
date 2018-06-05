import React from 'react'
import PropTypes from 'prop-types'

export default class Input extends React.Component {
  constructor(props){
    super(props);

    this.state = {
      value: this.props.value, placeholder: props.placeholder
    };
  }

  handleChange() {
    let update = {}
    update[this.props.attribute] = this.state.value
    this.props.handler(update)
  }

  render() {
    return(
      <input type='text' placeholder={this.props.placeholder} value={this.state.value}
             onChange={this.handleChange.bind(this)}/>
    )
  }
}