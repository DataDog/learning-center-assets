import React from 'react';
import ResponsiveContainer from 'recharts/lib/component/ResponsiveContainer';
import LineChart from 'recharts/lib/chart/LineChart';
import Line from 'recharts/lib/cartesian/Line';
import XAxis from 'recharts/lib/cartesian/XAxis';
import YAxis from 'recharts/lib/cartesian/YAxis';
import CartesianGrid from 'recharts/lib/cartesian/CartesianGrid';
import Tooltip from 'recharts/lib/component/Tooltip';
import Legend from 'recharts/lib/component/Legend';

const data = [
  { name: 'Mon', Users: 2200, GPH: 3400 },
  { name: 'Tue', Users: 1280, GPH: 2398 },
  { name: 'Wed', Users: 5000, GPH: 4300 },
  { name: 'Thu', Users: 4780, GPH: 2908 },
  { name: 'Fri', Users: 5890, GPH: 4800 },
  { name: 'Sat', Users: 4390, GPH: 3800 },
  { name: 'Sun', Users: 4490, GPH: 4300 },
];

function SimpleLineChart() {
  return (
    // 99% per https://github.com/recharts/recharts/issues/172
    <ResponsiveContainer width="99%" height={320}>
      <LineChart data={data}>
        <XAxis dataKey="name" />
        <YAxis />
        <CartesianGrid vertical={false} strokeDasharray="3 3" />
        <Tooltip />
        <Legend />
        <Line type="monotone" dataKey="Users" stroke="#82ca9d" />
        <Line type="monotone" dataKey="GPH" stroke="#8884d8" activeDot={{ r: 8 }} />
      </LineChart>
    </ResponsiveContainer>
  );
}

export default SimpleLineChart;
