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

function SimpleTable(props) {
  const { classes, pumps } = props

  function handlePumpStatusSwitch(e) {
    e.preventDefault()
    console.log(e.target.id)
  }
  return (
    <Paper className={classes.root}>
      <Table className={classes.table}>
        <TableHead>
          <TableRow>
            <TableCell>Pump Name</TableCell>
            <TableCell numeric>Pump Status</TableCell>
            <TableCell numeric>Gallons Per Hour</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {pumps.map(n => {
            return (
              <TableRow key={n.id}>
                <TableCell component="th" scope="row">
                  {n.name}
                </TableCell>
                <TableCell numeric><Switch id={n.id} checked={n.status == 'ON' ? 1: 0 } onClick={handlePumpStatusSwitch} disabled='true' color='primary' /></TableCell> {/*n.status*/}
                <TableCell numeric>{n.gph}</TableCell>

              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </Paper>
  );
}

SimpleTable.propTypes = {
  classes: PropTypes.object.isRequired,
  pumps: PropTypes.array.isRequired,
};

export default withStyles(styles)(SimpleTable);
