import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { withStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Drawer from '@material-ui/core/Drawer';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import List from '@material-ui/core/List';
import Typography from '@material-ui/core/Typography';
import Divider from '@material-ui/core/Divider';
import IconButton from '@material-ui/core/IconButton';
import Badge from '@material-ui/core/Badge';
import Paper from '@material-ui/core/Paper';
import MenuIcon from '@material-ui/icons/Menu';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import NotificationsIcon from '@material-ui/icons/Notifications';
import CloseIcon from '@material-ui/icons/Close';
import { mainListItems, secondaryListItems } from './listItems';
import SimpleLineChart from './SimpleLineChart';
import SimpleTable from './SimpleTable';
import UsersTable from './UsersTable'
import SensorsTable from './SensorsTable'
import Grid from '@material-ui/core/Grid';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Snackbar from '@material-ui/core/Snackbar';
import purple from '@material-ui/core/colors/purple';
import axios from 'axios';
import { isNumber } from 'recharts/lib/util/DataUtils';


const drawerWidth = 240;

var rootURL = ''

if (process.env.NODE_ENV == 'development') {
  rootURL='http://localhost:5000'
}

const styles = theme => ({
  root: {
    display: 'flex',
  },
  toolbar: {
    paddingRight: 24, // keep right padding when drawer closed
  },
  toolbarIcon: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-end',
    padding: '0 8px',
    ...theme.mixins.toolbar,
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
    transition: theme.transitions.create(['width', 'margin'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
  },
  appBarShift: {
    marginLeft: drawerWidth,
    width: `calc(100% - ${drawerWidth}px)`,
    transition: theme.transitions.create(['width', 'margin'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  menuButton: {
    marginLeft: 12,
    marginRight: 36,
  },
  menuButtonHidden: {
    display: 'none',
  },
  title: {
    flexGrow: 1,
  },
  drawerPaper: {
    position: 'relative',
    whiteSpace: 'nowrap',
    width: drawerWidth,
    transition: theme.transitions.create('width', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  drawerPaperClose: {
    overflowX: 'hidden',
    transition: theme.transitions.create('width', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    width: theme.spacing.unit * 7,
    [theme.breakpoints.up('sm')]: {
      width: theme.spacing.unit * 9,
    },
  },
  appBarSpacer: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing.unit * 3,
    height: '100vh',
    overflow: 'auto',
  },
  chartContainer: {
    marginLeft: -22,
  },
  tableContainer: {
    
  },
  paper: {
    marginTop: theme.spacing.unit * 3,
    marginBottom: theme.spacing.unit * 3,
    padding: theme.spacing.unit * 1.5,
  },
  textField: {
    marginLeft: theme.spacing.unit,
    marginRight: theme.spacing.unit,
    width: 400,
  },
  submitButton: {
      marginLeft: theme.spacing.unit,
      marginRight: theme.spacing.unit,
      marginTop: theme.spacing.unit + 20,
      marginBottom: theme.spacing.unit + 20,
      width: 100,
  },
  trafficButton: {
    marginLeft: theme.spacing.unit,
    marginRight: theme.spacing.unit,
    marginTop: theme.spacing.unit,
    marginBottom: theme.spacing.unit,
  }
});

class Dashboard extends React.Component {
  state = {
    open: false,
    pumpStatus: [{'id': 1, 'name': 'Pump 1', 'status': 'ON', 'gph': 400}],
    userStatus: [{'id': 1, 'uid': '42023-12024-4951A', 'name': 'Test City', 'demand_gph': 10, 'users': 200}],
    sensorsStatus: [{'id': 1, 'name': 'Test Sensor', 'value': 100, 'added': Date.now(), 'site': 'Naples'}],
    requestsOpen: false,
    requestCount: 0,
    newUser: {'name': '', 'demand_gph': '', 'users': ''},
    userList: []
  };

  pollForSensors = () => {
    setTimeout(() => {
      this.simulateSensorReads()
      this.pollForSensors()
    }, 3000)
  }

  componentDidMount = () => {
    
    axios.get(rootURL + "/status", { crossdomain: true }).then(response => {
      console.log(response.data)
      this.setState({pumpStatus: response.data.pump_status.status})
      this.setState({userStatus: response.data.users})
      this.setState({sensorsStatus: response.data.sensor_status.system_status})
    })

    this.pollForSensors()
  }

  simulateSensorReads = () => {
    axios.get(rootURL + "/simulate_sensors", {crossdomain: true}).then(response => {
      //console.log(response.data)
      this.setState({sensorsStatus: response.data.system_status})
    })
  }

  handleNewPump = (e) => {
    e.preventDefault()
    axios.post(rootURL + "/add_pump", {crossdomain: true}).then(response => {
      this.setState({pumpStatus: response.data})
    })
  }
  handleRequestConcurrent = (e) => {
    e.preventDefault()

    // have to do this because there's a gap in buttons :/
    if (e.target.id) {
      const concurrent = e.target.id / 10
      const total = e.target.id
      axios.post(rootURL + "/generate_requests", 
      {'concurrent': concurrent,
      'total': total,
      'url': '/users'},
      {crossdomain: true}).then(response => {
        this.setState({requestsOpen: true, requestCount: total})
      })
    } else {
      const concurrent = e.target.parentElement.id / 10
      const total = e.target.parentElement.id
      axios.post(rootURL + "/generate_requests", 
      {'concurrent': concurrent,
      'total': total,
      'url': '/users'},
      {crossdomain: true}).then(response => {
        this.setState({requestsOpen: true, requestCount: total})
      })
    }
  }

  handleUserRequestConcurrent = (e) => {
    e.preventDefault()
    axios.get(rootURL + "/generate_requests_user",
      {crossdomain: true}).then(response => {
        this.setState({requestsOpen: true, requestCount: 100})
    })
  }

  handleUserSubmit = (e) => {
    e.preventDefault()
    axios.post(rootURL + '/users', this.state.newUser, {crossdomain: true}).then(response => {
      console.log(response.data)
      axios.get(rootURL + "/status", { crossdomain: true }).then(response => {
        this.setState({userStatus: response.data.users})
      })
    })
    console.log(this.state.newUser)
    console.log('user submitted')
  }

  handleUserChange = (e) => {
    let newUserForm = Object.assign({}, this.state.newUser)
    newUserForm[e.target.id] = e.target.value
    this.setState({newUser: newUserForm});
  }

  handleConcurrentClose = (event, reason) => {
    if (reason === 'clickaway') {
      return;
    }

    this.setState({ requestsOpen: false });
  }

  handleDrawerOpen = () => {
    this.setState({ open: true });
  };

  handleDrawerClose = () => {
    this.setState({ open: false });
  };

  render() {
    const { classes } = this.props;

    return (
      <React.Fragment>
        <CssBaseline />
        <div className={classes.root}>
          <AppBar
            position="absolute"
            className={classNames(classes.appBar, this.state.open && classes.appBarShift)}
          >
            <Toolbar disableGutters={!this.state.open} className={classes.toolbar}>
              <IconButton
                color="inherit"
                aria-label="Open drawer"
                onClick={this.handleDrawerOpen}
                className={classNames(
                  classes.menuButton,
                  this.state.open && classes.menuButtonHidden,
                )}
              >
                <MenuIcon />
              </IconButton>
              <Typography variant="title" color="inherit" noWrap className={classes.title}>
                Dashboard
              </Typography>
              <IconButton color="inherit">
                <Badge badgeContent={0}>
                  <NotificationsIcon />
                </Badge>
              </IconButton>
            </Toolbar>
          </AppBar>
          <Drawer
            variant="permanent"
            classes={{
              paper: classNames(classes.drawerPaper, !this.state.open && classes.drawerPaperClose),
            }}
            open={this.state.open}
          >
            <div className={classes.toolbarIcon}>
              <IconButton onClick={this.handleDrawerClose}>
                <ChevronLeftIcon />
              </IconButton>
            </div>
            <Divider />
            <List>{mainListItems}</List>
            <Divider />
            <List>{secondaryListItems}</List>
          </Drawer>
          <main className={classes.content}>
            <div className={classes.appBarSpacer} />
            <Typography variant="display1" gutterBottom>
              Water Demand 
            </Typography>
            <Typography component="div" className={classes.chartContainer}>
              <SimpleLineChart />
            </Typography>
            <Typography variant="display1" gutterBottom>
              Pump Status <Button style={{float: 'right'}} variant="contained" color="primary" onClick={this.handleNewPump}>
                Add Pump
              </Button>
            </Typography>
            <div className={classes.tableContainer}>
              <SimpleTable  pumps={this.state.pumpStatus}/>
            </div>
            <div className={classes.appBarSpacer} />
            <Typography variant="display1" gutterBottom>
            City Water Sensor Status
            </Typography>
            <div className={classes.tableContainer}>
              <SensorsTable  sensors={this.state.sensorsStatus}/>
            </div>
            <div className={classes.appBarSpacer} />
            <Typography variant="display1" gutterBottom>
            City Water Usage
            </Typography>
            <div className={classes.tableContainer}>
              <UsersTable  users={this.state.userStatus}/>
            </div>
            <div className={classes.appBarSpacer} />
            
            <Grid container direction="row" justify="space-around"
            alignItems="stretch"
            >
            <Paper className={classes.paper}>
            <div className={classes.appBarSpacer} />
            <Typography align="center" variant="display1" gutterBottom>
            Add City to Water System
            </Typography>
            <Grid item xs={12}>
            
            <TextField
              id="name"
              label="City name"
              placeholder="City Name"
              className={classes.textField}
              margin="normal"
              value={this.state.newUser.name}
              onChange={this.handleUserChange}
             />
             </Grid>
             <Grid item xs>
            <TextField 
              id="demand_gph"
              label="Demand in GPH"
              placeholder="400"
              className={classes.textField}
              margin="normal"
              value={this.state.newUser.demand_gph}
              onChange={this.handleUserChange}
            />
            </Grid>
            <Grid item xs>
            <TextField 
              id="users"
              label="Total Water Users"
              placeholder="1000"
              className={classes.textField}
              margin="normal"
              value={this.state.newUser.users}
              onChange={this.handleUserChange}
            />
            </Grid>
            <Grid item xs>
            <Button style={{float: 'right' }} size="large" variant="contained" color="primary" className={classes.submitButton} onClick={this.handleUserSubmit}>
                Create City
            </Button>
            </Grid>
            </Paper>
            <Paper className={classes.paper}>
                      <div className={classes.appBarSpacer} />
            <Typography align="center" variant="display1" gutterBottom>
              Generate API Traffic
            </Typography>
            <br />
            <Button id="100" className={classes.trafficButton} size="large" variant="contained" color="default" onClick={this.handleRequestConcurrent}>
                100 users @ 10 concurrent requests
            </Button>
            <br /><Button id="200" className={classes.trafficButton} size="large" variant="contained" color="primary" onClick={this.handleRequestConcurrent}>
                200 users @ 20 concurrent requests
            </Button>
            <br /><Button id="300" className={classes.trafficButton} size="large" variant="contained" color="secondary" onClick={this.handleRequestConcurrent}>
                300 users @ 30 concurrent requests
            </Button>
            <br /><Button id="100" style={{backgroundColor: purple[500]}} className={classes.trafficButton} size="large" variant="contained" color="secondary" onClick={this.handleUserRequestConcurrent}>
                Generate Requests for Random User
            </Button>
          </Paper>
            </Grid>
            </main>
          <Snackbar
          anchorOrigin={{
            vertical: 'bottom',
            horizontal: 'left',
          }}
          open={this.state.requestsOpen}
          autoHideDuration={1000}
          onClose={this.handleConcurrentClose}
          ContentProps={{
            'aria-describedby': 'message-id',
          }}
          message={<span id="message-id">{ this.state.requestCount } requests created @ { this.state.requestCount / 10} concurrent requests. </span>}
          action={[
            <IconButton
              key="close"
              aria-label="Close"
              color="inherit"
              className={classes.close}
              onClick={this.handle100Close}
            >
              <CloseIcon />
            </IconButton>,
          ]}
        />
        </div>
      </React.Fragment>
    );
  }
}

Dashboard.propTypes = {
  classes: PropTypes.object.isRequired
};

export default withStyles(styles)(Dashboard);
