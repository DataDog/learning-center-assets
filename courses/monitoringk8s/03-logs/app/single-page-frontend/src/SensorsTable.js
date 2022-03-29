import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import Switch from '@material-ui/core/Switch';

const styles = {
  root: {
    width: '100%',
    overflowX: 'auto',
  },
  table: {
    minWidth: 700,
  },
};

function SensorsTable(props) {
  const { classes, sensors } = props

  function handlePumpStatusSwitch(e) {
    e.preventDefault()
    console.log(e.target.id)
  }
  return (
    <Paper className={classes.root}>
      <Table className={classes.table}>
        <TableHead>
          <TableRow>
            <TableCell>Sensor Name</TableCell>
            <TableCell numeric>Sensor Site</TableCell>
            <TableCell numeric>Sensor Value</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {sensors.map(n => {
            return (
              <TableRow key={n.id}>
                <TableCell component="th" scope="row">
                  {n.name}
                </TableCell>
                <TableCell numeric>{n.site}</TableCell>
                <TableCell numeric>{n.value}</TableCell>

              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </Paper>
  );
}

SensorsTable.propTypes = {
  classes: PropTypes.object.isRequired,
  sensors: PropTypes.array.isRequired,
};

export default withStyles(styles)(SensorsTable);
