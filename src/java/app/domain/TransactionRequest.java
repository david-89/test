package app.domain;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

@Entity
public class TransactionRequest implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private double amount;
    private double rate;
    @OneToOne(fetch = FetchType.EAGER)
    private Client client;
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "transactionRequest")
    private List<TransactionOffer> transactionOffers;

    public TransactionRequest() {
    }

    public String JSONify() {
        return "{'id':" + id + ",'amount':" + amount + ",'rate':" + rate + ",'client':" + client.JSONify() + "}";
    }

    public String JSONifyAbbreviated() {
        return "{'id':" + id + ",'amount':" + amount + ",'rate':" + rate + "}";
    }

    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return the amount
     */
    public double getAmount() {
        return amount;
    }

    /**
     * @param amount the amount to set
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public double getRate() {
        return rate;
    }

    /**
     * @param rate the rate to set
     */
    public void setRate(double rate) {
        this.rate = rate;
    }

    public List<TransactionOffer> getTransactionOffers() {
        return transactionOffers;
    }

    public void setTransactionOffers(List<TransactionOffer> transactionOffers) {
        this.transactionOffers = transactionOffers;
    }
}
