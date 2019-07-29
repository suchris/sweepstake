import React from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "drizzle-react-components";

import logo from "./sweepstake.jpeg";

export default ({ accounts }) => (
  <div className="App">
    <div>
      <img src={logo} alt="drizzle-logo" />
      <h1>Sweepstake</h1>
    </div>

    <div className="section">
      <h2>Active Account</h2>
      <AccountData accountIndex={0} units="ether" precision={4} />
    </div>

    <div className="section">
      <h2>Sweepstake Factory</h2>
      <p>
        This allows anyone to create sweepstake with name and prize
      </p>
      <p>
        <strong>Create Sweepstake</strong>
        <ContractForm
          contract="SweepstakeFactory"
          method="createSweepstake"
          labels={["Sweepstake Name", "10000000000000000"]}
          sendArgs={{value:'10000000000000000'}}
        />
      </p>
    </div>
    
  </div>
    
);
