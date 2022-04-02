// ---*< React/Next Imports >*-----------------------------------------
import {useEffect, useState} from "react";

// ---*< Third-party Imports >*----------------------------------------
import {Grid, Label, List} from "semantic-ui-react";

// ---*< Local Imports >*----------------------------------------------
import Layout from "../components/Layout";
import WalletButton from "../components/WalletButton";
import {exchange, getCdtBalance, getLpBalance} from "../eth/dex";
import web3 from "../eth/web3";

// ---*< Declarations >*-----------------------------------------------

// ---*< Code >*-------------------------------------------------------
const Index = () => {
    // const acct = await web3.eth.getAccounts();
    const [dex, setDex] = useState(null);
    const [acct, setAcct] = useState(null);
    const [ethBalance, setEthBalance] = useState(null);
    const [cdtBalance, setCdtBalance] = useState(null);
    const [lpBalance, setLpBalance] = useState(null);
    const [connected, setConnected] = useState(false);

    useEffect(async () => {
        setDex(exchange.options.address);

        if (connected){
            const acct = await web3.eth.getAccounts();
            setAcct(acct[0]);
            setEthBalance(web3.utils.fromWei(
                await web3.eth.getBalance(acct[0]), "ether"
            ));
            setCdtBalance(
                (await getCdtBalance(acct[0])) / 10**18
            );
            setLpBalance(
                (await getLpBalance(acct[0])) / 10**18
            );
        }
    }, []);

    return (
        <Layout>
            {/*<List selection divided>*/}
            {/*    <List.Item>*/}
            {/*        <Label horizontal>Dex address</Label>*/}
            {/*        {dex}*/}
            {/*    </List.Item>*/}
            {/*    <List.Item>*/}
            {/*        <Label horizontal>Wallet address</Label>*/}
            {/*        {acct}*/}
            {/*    </List.Item>*/}
            {/*    <List.Item>*/}
            {/*        <Label horizontal>Eth balance:</Label>*/}
            {/*        {ethBalance}*/}
            {/*    </List.Item>*/}
            {/*    <List.Item>*/}
            {/*        <Label horizontal>CD Token balance:</Label>*/}
            {/*        {cdtBalance}*/}
            {/*    </List.Item>*/}
            {/*    <List.Item>*/}
            {/*        <Label horizontal>Liquidity Provider Token balance:</Label>*/}
            {/*        {lpBalance}*/}
            {/*    </List.Item>*/}
            {/*</List>*/}

            <Grid columns="equal">
                <Grid.Row>
                    <Grid.Column textAlign="right">
                        <Label horizontal>Dex address</Label>
                    </Grid.Column>
                    <Grid.Column>{dex}</Grid.Column>
                </Grid.Row>
                <Grid.Row>
                    <Grid.Column textAlign="right">
                        <Label horizontal>Wallet address</Label>
                    </Grid.Column>
                    <Grid.Column>{acct}</Grid.Column>
                </Grid.Row>
                <Grid.Row>
                    <Grid.Column textAlign="right">
                        <Label horizontal>Eth balance:</Label>
                    </Grid.Column>
                    <Grid.Column>{ethBalance}</Grid.Column>
                </Grid.Row>
                <Grid.Row>
                    <Grid.Column textAlign="right">
                        <Label horizontal>CD Token balance:</Label>
                    </Grid.Column>
                    <Grid.Column>{cdtBalance}</Grid.Column>
                </Grid.Row>
                <Grid.Row>
                    <Grid.Column textAlign="right">
                        <Label horizontal>Liquidity Provider Token balance:</Label>
                    </Grid.Column>
                    <Grid.Column>{lpBalance}</Grid.Column>
                </Grid.Row>
            </Grid>

            <WalletButton getter={connected} setter={setConnected}/>
        </Layout>
    );
};

// ---*< Exports >*----------------------------------------------------
export default Index;