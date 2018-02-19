import * as React from 'react';

interface Props {
  name: string;
};

const Hello = (p: Props) => (
  <div>Hello {p.name}!</div>
);

export default Hello;
